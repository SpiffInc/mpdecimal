
nif_interface = [
  %{function: ["mpd_iseven",
               "mpd_isfinite",
               "mpd_isinfinite",
               "mpd_isinteger",
               "mpd_isnan",
               "mpd_isnegative",
               "mpd_isnormal",
               "mpd_isodd",
               "mpd_isoddcoeff",
               "mpd_isoddword",
               "mpd_ispositive",
               "mpd_isqnan"],
    signature: %{
      return: %{var: "result", c_type: "int",           erl_dir: "out", erl_type: "boolean"},
      args:  [%{var: "dec",    c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}]
    }
  }
]

# Tests
# - Cannot have a return map with erl_dir: "out" and an argument map with erl_dir: "out"?
# - All variable names in a function signature must be unique.
# - A return map with c_type: "void" has no other keys.
# - For resources, the c_type and erl_type match.
# - If multiple argument maps with erl_dir: "out" exist in the same signature, they each have a unique value for the :erl_tuple key.

# Strings produced by functions in this module do not end with a newline.
defmodule NifGen do

  def declare_args([arg | []]) do
    declare_var(arg)
  end

  def declare_args([arg | args]) do
    declare_var(arg) <> "\n" <> declare_args(args)
  end

  def declare_nif(function) do
    define_nif(function) <> ";"
  end

  def define_nif(function) do
    "ERL_NIF_TERM" <> function_name(function) <> "(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])"
  end

  def function_name(function) do
    function <> "_wrapper"
  end

  def declare_var(%{c_type: "void"}) do
    ""
  end

  def declare_var(%{c_type: c_type, var: var}) do
    # c_type <> " " <> var <> ";"
    "#{c_type} #{var};"
  end

  def indent(string, n) do
    [first_line | tail] = String.split(string, "\n")
    # No need to indent the first line of the string.
    first_line <> indent_lines(tail, n)
  end
  
  def indent(nil, _n) do
    nil
  end 

  def indent_lines([], _n) do
    ""
  end

  def indent_lines([line | tail], n) do
    "\n" <> String.duplicate(" ", n) <> line <> indent_lines(tail, n)
  end

  def enif_arg_format([arg | []]) do
    "!" <> arg
  end
  
  def enif_arg_format([arg | tail]) do
    "!" <> arg <> " ||\n" <> enif_arg_format(tail)
  end
  
  def enif_get_arg(%{erl_dir: "in", erl_type: "resource_mpd_t_pp", var: var}, argn) do
    "enif_get_resource(env, argv[#{argn}], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t_pp, (void**) &#{var})"
  end

  def enif_get_arg(%{}, _) do
    ""
  end

  def enif_args_format(args) do
    Enum.with_index(args, fn arg, argn -> enif_get_arg(arg, argn) end)
    |> Enum.reject(fn arg -> arg == "" end)
    |> enif_arg_format()
  end

  def process_args(args) do
    argc = Enum.count(args, fn arg -> match?(%{erl_dir: "in"}, arg) end)
    case argc do
      0 ->
        # TODO: Does this case actually exist?
        "if (argc != 0) {\n" <>
        "  return enif_make_badarg(env);\n" <>
        "}"
      _ ->
        "if ((argc != #{argc}) ||\n" <>
        "    #{enif_args_format(args) |> indent(4)}) {\n" <>
        "  return enif_make_badarg(env);\n" <>
        "}"
    end
  end

  def use_arg(%{var: var, erl_type: "resource_mpd_t_pp"}) do
    "*" <> var
  end

  def use_arg(%{var: var}) do
    var
  end

  def list_args([arg | []]) do
    "#{use_arg(arg)}"
  end

  def list_args([arg | tail]) do
    "#{use_arg(arg)}, " <> list_args(tail)
  end

  def list_registry([reg | []]) do
    "#{reg}"
  end

  def list_registry([reg | list]) do
    "#{reg},\n" <> list_registry(list)
  end

  def mpd_function(%{c_type: "void"}, function, args) do
    # "(void)" <> function <> "(" <> list_args(args)  <> ")"
    "(void) #{function}(#{list_args(args)})"
  end

  def mpd_function(%{var: return_var}, function, args) do
    # return_var <> " = " <> function <> "(" <> list_args(args) <>");"
    "#{return_var} = #{function}(#{list_args(args)});"
  end

  def return(%{var: var, c_type: "int", erl_dir: "out", erl_type: "boolean"}) do
    "return enif_make_boolean(env, #{var});"
  end

  def return(%{c_type: "void"}) do
    # TODO
    ""
  end
end

for function_list <- nif_interface do
  return = Map.get(function_list, :signature) |> Map.get(:return)
  args = Map.get(function_list, :signature) |> Map.get(:args)

  for function <- Map.get(function_list, :function) do
    "#{NifGen.declare_nif(function)}" |> IO.puts
  end

  IO.puts("")

  for function <- Map.get(function_list, :function) do
    """
    #{NifGen.define_nif(function)}
    {
      #{NifGen.declare_var(return) |> NifGen.indent(2)}
      #{NifGen.declare_args(args) |> NifGen.indent(2)}

      #{NifGen.process_args(args) |> NifGen.indent(2)}
    
      #{NifGen.mpd_function(return, function, args) |> NifGen.indent(2)}

      #{NifGen.return(return) |> NifGen.indent(2)}
    }
    """
    |> IO.puts
  end

  argc = Enum.count(args, fn arg -> match?(%{erl_dir: "in"}, arg) end)

  registry = for function <- Map.get(function_list, :function) do
               "{\"#{function}\", #{argc}, #{NifGen.function_name(function)}}"
             end
  """
  ErlNifFunc funcs[] = {
    #{NifGen.list_registry(registry) |> NifGen.indent(2)}
  }
  """
  |> IO.puts
end
