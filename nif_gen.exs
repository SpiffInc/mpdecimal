
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
      return: %{var: "result",  c_type: "int",           erl_dir: "out", erl_type: "boolean"},
      args:  [%{var: "dec",     c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t"}]
    }
  }
]

# Strings produced by functions in this module do not end with a newline.
defmodule NifGen do

  def declare_arg([]) do
    ""
  end

  def declare_arg([arg | list]) do
    "\n" <> declare_var(arg) <> declare_arg(list)
  end

  def declare_args(args) do
    declare_arg(args)
    [first_arg | list] = args
    declare_var(first_arg) <> declare_arg(list)
  end

  def declare_var(%{c_type: "void"}) do
    ""
  end

  def declare_var(var = %{}) do
    "#{Map.get(var, :c_type)} #{Map.get(var, :var)};"
  end

  def define_nif(function) do
    "ERL_NIF_TERM #{function}_wrapper(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])"
  end

  def indent_line([], _n) do
    ""
  end

  def indent_line([line | list], n) do
    "\n" <> String.duplicate(" ", n) <> line <> indent_line(list, n)
  end

  def indent(nil, _n) do
  end
  
  def indent(string, n) do
    [first_line | list] = String.split(string, "\n")
    # No need to indent the first line of the string.
    first_line <> indent_line(list, n)
  end

  def enif_arg_format([]) do
  end

  def enif_arg_format([arg]) do
    "!" <> arg
  end

  def enif_arg_format([arg | list]) do
    "!" <> arg <> " ||\n"<> enif_arg_format(list)
  end
  
  def enif_get_arg(%{erl_dir: "in", erl_type: "resource_mpd_t"} = arg, argn) do
    "enif_get_resource(env, argv[#{argn}], ((priv_data_t*) enif_priv_data(env))->resource_mpd_t, (void**) &#{Map.get(arg, :var)})"
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
    # TODO Count the number of input arguments.
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

  def use_arg(%{var: var, erl_type: "resource_mpd_t"}) do
    "*#{var}"
  end

  def list_arg([]) do
    ""
  end

  def list_arg([arg | list]) do
    ", #{use_arg(arg)}" <> list_arg(list)
  end

  def list_args(args) do
    [first_arg | list] = args
    "#{use_arg(first_arg)}" <> list_arg(list)
  end

  def mpd_function(return, function, args) do
    Map.get(return, :var) <> " = #{function}(#{list_args(args)});"
  end

  def return(%{var: var, c_type: "int", erl_dir: "out", erl_type: "boolean"}) do
    "return enif_make_boolean(env, #{var});"
  end
end

for function_list <- nif_interface do
  return = Map.get(function_list, :signature) |> Map.get(:return)
  args = Map.get(function_list, :signature) |> Map.get(:args)
  
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
end




