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
  }
]

# Tests
# - Cannot have a return map with erl_dir: "out" and an argument map with erl_dir: "out"?
# - All variable names in a function signature must be unique.
# - A return map with c_type: "void" has no other keys.
# - For resources, the c_type and erl_type match.
# - If multiple argument maps with erl_dir: "out" exist in the same signature, they each have a unique value for the :erl_tuple key.

defmodule NifGen do

  def append([line | []], string) do
    [line <> string]
  end

  def append([line | lines], string) do
    [line | append(lines, string)] 
  end

  # TODO: Should the call to enif_make_resource be delayed until after the MPD function call?
  def create_term(%{var: var, c_type: c_type, erl_dir: "out", erl_type: "resource_mpd_t_pp"}) do
    [
      "#{var} = enif_alloc_resource(RESOURCE_MPD_T_PP, sizeof(#{c_type}));",
      "*#{var} = mpd_new(&ctx);",
      "#{var}_term = enif_make_resource(env, #{var});",
      "enif_release_resource(#{var});",
      "if (ctx.newtrap) {",
        "return nif_make_error_tuple(env, &ctx);" |> indent,
      "}"
    ]
  end

  def create_term(%{erl_dir: "out"}) do
    # TODO: Error
    []
  end

  def create_term(_) do
    # TODO: Not an error.
    []
  end

  def create_terms(args) do
    Enum.map(args, &create_term(&1))
  end

  def use_out_term(%{erl_dir: "out", var: var}) do
    "#{var}_term"
  end
  
  def declare_out_term(arg = %{erl_dir: "out"}) do
    ["ERL_NIF_TERM #{use_out_term(arg)};"]
  end

  def declare_out_term(_) do
    []
  end

  def declare_out_terms(args) when is_list(args) do
    Enum.map(args, &declare_out_term(&1))
  end

  def declare_nif(function) do
    [nif_header(function) <> ";"]
  end

  def declare_nifs(%{function: function_list}) do
    Enum.map(function_list, &NifGen.declare_nif(&1))
  end

  def declare_var(%{c_type: "void"}) do
    []
  end

  def declare_var(%{c_type: c_type, var: var}) do
    "#{c_type} #{var};"
  end

  def declare_var(_) do
    # TODO: Error?
    []
  end

  def declare_vars(vars) do
    Enum.map(vars, &declare_var(&1))
  end

  def define_nif(function, signature = %{return: return, args: args, context: context}) do
    [
      nif_header(function),
      "{",
        [
          declare_vars([return | args]),
          declare_out_terms(args),
          process_args(args),
          init_context(context),
          create_terms(args),
          call_function(function, signature),
          return(return, args)
        ]
        |> indent
        |> space,
      "}"
    ]
  end

  def define_nifs(%{function: function_list, signature: signature}) do
    Enum.map(function_list, &NifGen.define_nif(&1, signature))
  end

  def indent(lines, n \\ 4)
  
  def indent(lines, n) when is_list(lines) do
    Enum.map(lines, &indent_line(&1, n))
  end

  def indent(line, n) do
    indent_line(line, n)
  end

  # Enable recursive indentation of nested lists of lines.
  defp indent_line(lines, n) when is_list(lines) do
    indent(lines, n)
  end

  defp indent_line("", _n) do
    ""
  end

  defp indent_line(line, n) do
    String.duplicate(" ", n) <> line
  end
  
  def init_context(false) do
    []
  end

  # Custom
  def init_context(true) do
    ["mpd_context_t ctx = nif_copy_context(env);"]
  end

  # Custom
  def enif_get_arg(%{erl_dir: "in", erl_type: "int64", var: var}, argn) do
    "enif_get_int64(env, argv[#{argn}], &#{var})"
  end
  
  # Custom
  def enif_get_arg(%{erl_dir: "in", erl_type: "uint64", var: var}, argn) do
    "enif_get_uint64(env, argv[#{argn}], &#{var})"
  end

  # Custom
  def enif_get_arg(%{erl_dir: "in", erl_type: "resource_mpd_t_pp", var: var}, argn) do
    "enif_get_resource(env, argv[#{argn}], RESOURCE_MPD_T_PP, (void**) &#{var})"
  end

  def enif_get_arg(%{}, _) do
    # TODO: Error?
    [] 
  end

  def enif_get_args(args) do
    Enum.with_index(args, &(enif_get_arg(&1, &2)))
    |> Enum.map(&("!" <> &1))
    |> delimit(" ||")
  end

  def process_args(args) do
    args_in = Enum.filter(args, fn arg -> match?(%{erl_dir: "in"}, arg) end)
    argc_in = Enum.count(args_in) 
    case argc_in do
      0 ->
        # TODO: Does this case actually exist?
        [
          "if (argc != 0) {",
            "return enif_make_badarg(env);" |> indent,
          "}"
        ]
      _ ->
        [
          "if ((argc != #{argc_in}) ||",
               enif_get_args(args_in)
               |> append(") {")
               |> indent(4),
            "return enif_make_badarg(env);" |> indent,
          "}"
        ]
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
    |> Enum.map(&Enum.join(&1))
  end

  # TODO:
  # Check for new traps when context is true.
  def call_function(function, %{return: return, args: args, context: context}) do
    call_function(return, function, args, context)
  end

  def call_function(_return = %{c_type: "void"}, function, args, _context = false) do
    ["#{function}(#{list_args(args)});"]
  end
  
  def call_function(_return = %{c_type: "void"}, function, args, _context = true) do
    ["#{function}(#{list_args(args)}, &ctx);"]
  end
  
  def call_function(%{var: return_var}, function, args, _context = false) do
    ["#{return_var} = #{function}(#{list_args(args)});"]
  end
  
  def call_function(%{var: return_var}, function, args, _context = true) do
    ["#{return_var} = #{function}(#{list_args(args)}, &ctx);"]
  end

  def nif_header(function) do
    "ERL_NIF_TERM #{nif_name(function)}(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])"
  end

  def nif_name(function) do
    "nif_" <> function
  end

  def nif_registry(entries) do
    [
      "ErlNifFunc funcs[] = {",
        entries |> indent,
      "};"
    ]
  end

  def print(code) do
    code
    |> List.flatten
    |> NifGen.delimit("\n")
    |> IO.puts
  end

  def register_nif(function, %{args: args}) do
    argc_in = Enum.count(args, &match?(%{erl_dir: "in"}, &1))
    ["{\"#{function}\", #{argc_in}, #{NifGen.nif_name(function)}}"]
  end

  def register_nifs(%{function: function_list, signature: signature}) do
    Enum.map(function_list, &NifGen.register_nif(&1, signature))
  end

  def return(%{c_type: "int", erl_dir: "out", erl_type: "boolean", var: var}, _) do
    ["return enif_make_boolean(env, #{var});"]
  end

  def return(%{erl_dir: "none"}, args) do
    out_args = Enum.filter(args, fn arg -> match?(%{erl_dir: "out"}, arg) end) 
    out_argc = Enum.count(out_args)
    return_statement(out_args, out_argc)
  end

  def return(_, _) do
    []
  end

  def return_statement(_, 0) do
    #TODO: Error
    []
  end

  def return_statement([out_arg], 1) do
    ["return #{use_out_term(out_arg)};"]
  end

  def return_statement(out_args, out_argc) do
    # TODO: use_out_args
    ["return enif_make_tuple#{out_argc}(#{list_args(out_args)});"]
  end

  def space(code) when is_list(code) do
    # Reject any empty lists or any lists containing only empty lists (of any
    # arbitrary nesting level). Intersperse empty strings to space code blocks.
    code
    |> Enum.reject(&(&1 |> List.flatten |> Enum.empty?))
    |> Enum.intersperse("")
  end
end

# Declare NIFs
Enum.reduce(nif_interface, [], &(NifGen.declare_nifs(&1) ++ &2))
|> Enum.sort
|> NifGen.print

IO.puts("")

# Define NIFs
Enum.reduce(nif_interface, [], &(NifGen.define_nifs(&1) ++ &2))
|> Enum.sort
|> NifGen.space
|> NifGen.print

IO.puts("")

# Register NIFs
Enum.reduce(nif_interface, [], &(NifGen.register_nifs(&1) ++ &2))
|> Enum.sort
|> NifGen.delimit(",")
|> NifGen.nif_registry
|> NifGen.print

IO.puts("")
