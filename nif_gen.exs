# Not Implemented
#
# The expectations regarding the size of some custom integer types  are not compatible with the Erlang NIF interface.
# mpd_abs_uint
# mpd_add_i32
#
# context-related
# mpd_addstatus_raise


# Some of these functions have a non-void return type, but in all cases the
# information returned by the function is also encoded in the mpd_t* result
# argument.

# Side Effects
# MPD MINALLOC is an unavoidable side-effect of using this library.

nif_interface = [
  %{
    signature:
    %{
      return: %{var: "result", c_type: "int",           erl_dir: "out", erl_type: "boolean"},
      
      args:
      [ 
              %{var: "dec",    c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: false
    },

    function:
    [
      "mpd_iseven",
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
      "mpd_isqnan"
    ]
  },

  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },
      
      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_abs",
      "mpd_canonical",
      "mpd_ceil",
      "mpd_copy",
      "mpd_copy_abs",
      "mpd_copy_negate",
      "mpd_exp",
      "mpd_floor",
      "mpd_invert",
      "mpd_invroot",
      "mpd_ln",
      "mpd_log10",
      "mpd_logb",
      "mpd_minus",
      "mpd_next_minus",
      "mpd_next_plus",
      "mpd_next_reduce",
      "mpd_round_to_int",
      "mpd_round_to_intx",
      "mpd_sqrt",
      "mpd_trunc"
    ]
  },

  %{
    signature:
    %{
      return: %{var: "",       c_type: "int",           erl_dir: "out", erl_type: "int"              },
      
      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_check_nan"
    ]
  },

  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "b",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_add",
      "mpd_and",
      "mpd_check_nans",
      "mpd_compare",
      "mpd_compare_signal",
      "mpd_copy_sign",
      "mpd_max",
      "mpd_max_mag",
      "mpd_min",
      "mpd_min_mag",
      "mpd_mul",
      "mpd_next_toward",
      "mpd_or",
      "mpd_quantize",
      "mpd_rotate",
      "mpd_scaleb",
      "mpd_shift",
      "mpd_sub",
      "mpd_xor"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "b",      c_type: "int64_t",       erl_dir: "in",  erl_type: "int64"}
      ],

      context: true
    },

    function:
    [
      "mpd_add_i64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "b",      c_type: "uint64_t",      erl_dir: "in",  erl_type: "uint64"}
      ],

      context: true
    },

    function:
    [
      "mpd_add_u64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "b",      c_type: "int64_t",       erl_dir: "in",  erl_type: "int64"            }
      ],

      context: true
    },

    function:
    [
      "mpd_add_i64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{          c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "q", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "a", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "b", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_div",
      "mpd_divint"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "base",   c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "exp",    c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_pow"
    ]
  },
  
  %{
    signature:
    %{
      return: %{             c_type: "void",          erl_dir: "none"                              },

      args:
      [       
              %{var: "r",    c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{var: "base", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{var: "exp",  c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    function:
    [
      "mpd_rem",
      "mpd_rem_near"
    ]
  },
]

# Tests
# - Cannot have a return map with erl_dir: "out" and an argument map with erl_dir: "out"?
# - All variable names in a function signature must be unique.
# - A return map with c_type: "void" has no other keys.
# - For resources, the c_type and erl_type match.
# - If multiple argument maps with erl_dir: "out" exist in the same signature, they each have a unique value for the :erl_tuple key.

defmodule NifGen do

  def add_block(string, "") do
    string
  end

  def add_block(string, block) do
    string <> "\n" <> block
  end

  def create_term(%{var: var, c_type: c_type, erl_dir: "out", erl_type: "resource_mpd_t_pp"}) do
    "#{var} = enif_alloc_resource(RESOURCE_MPD_T_PP, sizeof(#{c_type}));\n" <>
    "*#{var} = mpd_new(&ctx);\n" <>
    "#{var}_term = enif_make_resource(env, #{var});\n" <>
    "enif_release_resource(#{var});\n" <>

    # TODO
    # MPD_CONTEXT_TRAP_CHECK
    "if (ctx.newtrap) {\n" <>
      "#{"return nif_make_error_tuple(env, &ctx);\n" |> indent(2)}" <>
    "}\n"
  end

  def create_term(%{erl_dir: "out"}) do
    # Error
    ""
  end

  def create_term(_) do
    #Error
    ""
  end

  def create_terms(args) do
    Enum.reduce(args, "", fn arg, string -> string |> add_block(create_term(arg)) end)
  end

  def use_out_term(%{erl_dir: "out", var: var}) do
    "#{var}_term"
  end

  def declare_out_term(arg = %{erl_dir: "out"}) do
    "ERL_NIF_TERM #{use_out_term(arg)};\n"
  end

  def declare_out_term(_) do
    ""
  end

  def declare_out_terms([]) do
    ""
  end

  def declare_out_terms([arg | args]) do
    declare_out_term(arg) <> declare_out_terms(args)
  end

  def declare_nif(function) do
    nif_header(function) <> ";"
  end

  def declare_nifs(%{function: function_list}) do
    function_list
    |> Enum.map(&NifGen.declare_nif(&1))
  end

  def declare_var(%{c_type: "void"}) do
    ""
  end

  def declare_var(%{c_type: c_type, var: var}) do
    "#{c_type} #{var};\n"
  end

  def declare_vars(vars) do
    Enum.map(vars, fn var -> declare_var(var) end)
    |> List.to_string
  end

  def define_nif(function, signature = %{return: return, args: args, context: context}) do
    nif_header(function) <> "\n" <>
    "{" <>
      "#{declare_vars([return | args])
         |> indent_block(2)}" <>

      "#{declare_out_terms(args)
         |> indent_block(2)}" <>

      "#{process_args(args)
         |> indent_block(2)}" <>

      "#{init_context(context)
         |> indent_block(2)}" <>

      "#{create_terms(args)
         |> indent(2)}" <>
    
      "#{call_function(function, signature)
         |> indent_block(2)}" <>

      "#{return(return, args)
         |> indent_block(2)}" <>
    "}\n"
  end

  def define_nifs(%{function: function_list, signature: signature}) do
    function_list
    |> Enum.map(&NifGen.define_nif(&1, signature))
  end

  def indent("", _n) do
    ""
  end

  # TODO: Remove guard?
  def indent(lines, n) when is_list(lines) do
    Enum.map(lines, &indent_line(&1,n))
  end

  def indent(string, n) do
    {last_line, line_list} = for line <- String.split(string, "\n") do
                               indent_line(line, n)
                             end
                             |> List.pop_at(-1)
    lines = for line <- line_list do
              line <> "\n"
            end
            |> List.to_string
    lines <> last_line
  end

  def indent_block("", _n) do
    ""
  end

  def indent_block(string, n) do
    "\n" <> indent(string, n)
  end

  def indent_line("", _n) do
    ""
  end

  def indent_line(line, n) do
    String.duplicate(" ", n) <> line
  end
  
  def init_context(false) do
    ""
  end

  def init_context(true) do
    "mpd_context_t ctx = nif_copy_context(env);\n"
  end

  def enif_arg_format([arg | []]) do
    "!" <> arg
  end
  
  def enif_arg_format([arg | tail]) do
    "!" <> arg <> " ||\n" <> enif_arg_format(tail)
  end

  def enif_get_arg(%{erl_dir: "in", erl_type: "int64", var: var}, argn) do
    "enif_get_int64(env, argv[#{argn}], &#{var})"
  end
  
  def enif_get_arg(%{erl_dir: "in", erl_type: "uint64", var: var}, argn) do
    "enif_get_uint64(env, argv[#{argn}], &#{var})"
  end

  def enif_get_arg(%{erl_dir: "in", erl_type: "resource_mpd_t_pp", var: var}, argn) do
    "enif_get_resource(env, argv[#{argn}], RESOURCE_MPD_T_PP, (void**) &#{var})"
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
    args_in = Enum.filter(args, fn arg -> match?(%{erl_dir: "in"}, arg) end)
    argc_in = Enum.count(args_in) 
    case argc_in do
      0 ->
        # TODO: Does this case actually exist?
        "if (argc != 0) {\n" <>
        "  return enif_make_badarg(env);\n" <>
        "}\n"
      _ ->
        "if ((argc != #{argc_in}) ||\n" <>
            "#{enif_args_format(args_in) |> indent(4)}) {\n" <>
        "  return enif_make_badarg(env);\n" <>
        "}\n"
    end
  end

  def use_arg(%{var: var, erl_type: "resource_mpd_t_pp"}) do
    "*" <> var
  end

  def use_arg(%{var: var}) do
    var
  end

  def list_args(args) do
    Enum.map(args, fn arg -> use_arg(arg) end)
    |> delimit(", ")
    |> List.to_string
  end

  def delimit(list, delimiter) do
    Enum.intersperse(list, delimiter)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_string(&1))
  end

  def append(list, string) do
    Enum.map(list, fn x -> x <> string end)
  end

  # TODO:
  # Check for new traps when context is true.
  def call_function(function, %{return: return, args: args, context: context}) do
    call_function(return, function, args, context)
  end

  def call_function(_return = %{c_type: "void"}, function, args, _context = false) do
    "#{function}(#{list_args(args)});\n"
  end
  
  def call_function(_return = %{c_type: "void"}, function, args, _context = true) do
    "#{function}(#{list_args(args)}, &ctx);\n"
  end
  
  def call_function(%{var: return_var}, function, args, _context = false) do
    "#{return_var} = #{function}(#{list_args(args)});\n"
  end
  
  def call_function(%{var: return_var}, function, args, _context = true) do
    "#{return_var} = #{function}(#{list_args(args)}, &ctx);\n"
  end

  def nif_header(function) do
    "ERL_NIF_TERM #{nif_name(function)}(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])"
  end

  def nif_name(function) do
    "nif_" <> function
  end

  def nif_registry(entries) do
    ["ErlNifFunc funcs[] = {"] ++
        (entries |> indent(2)) ++
    ["};"]
    |> Enum.intersperse("\n")
  end

  def register_nif(function, %{args: args}) do
    argc_in = Enum.count(args, &match?(%{erl_dir: "in"}, &1))
    "{\"#{function}\", #{argc_in}, #{NifGen.nif_name(function)}}"
  end

  def register_nifs(%{function: function_list, signature: signature}) do
    function_list
    |> Enum.map(&NifGen.register_nif(&1, signature))
  end

  def return(%{c_type: "int", erl_dir: "out", erl_type: "boolean", var: var}, _) do
    "return enif_make_boolean(env, #{var});\n"
  end

  def return(%{erl_dir: "none"}, args) do
    out_args = Enum.filter(args, fn arg -> match?(%{erl_dir: "out"}, arg) end) 
    out_argc = Enum.count(out_args)
    return_statement(out_args, out_argc)
  end

  def return(_, _) do
    ""
  end

  def return_statement(_, 0) do
    "ERROR"
  end

  def return_statement([out_arg], 1) do
    "return #{use_out_term(out_arg)};\n"
  end

  def return_statement(out_args, out_argc) do
    # TODO: use_out_args
    "return enif_make_tuple#{out_argc}(#{list_args(out_args)});\n"
  end
end

# Declare NIFs
Enum.reduce(nif_interface, [], &(&2 ++ NifGen.declare_nifs(&1)))
|> Enum.sort
|> Enum.intersperse("\n")
|> IO.puts

IO.puts("")

# Define NIFs
Enum.reduce(nif_interface, [], &(&2 ++ NifGen.define_nifs(&1)))
|> Enum.sort
|> Enum.intersperse("\n")
|> IO.puts

# Register NIFs
Enum.reduce(nif_interface, [], &(&2 ++ NifGen.register_nifs(&1)))
|> Enum.sort
|> NifGen.delimit(",")
|> NifGen.nif_registry
|> IO.puts
