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

libmpdec_interface = [
  %{
    signature:
    %{
      return: %{name: "result", c_type: "int",           erl_dir: "out", erl_type: "boolean"          },
      
      parameters:
      [ 
              %{name: "dec",    c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: false
    },

    functions:
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
      return: %{               c_type: "void",          erl_dir: "none"                               },
      
      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
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
      return: %{name: "",       c_type: "int",           erl_dir: "out", erl_type: "int"              },
      
      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
    [
      "mpd_check_nan"
    ]
  },

  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                              },

      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "b",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
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
      return: %{               c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "b",      c_type: "int64_t",       erl_dir: "in",  erl_type: "int64"            }
      ],

      context: true
    },

    functions:
    [
      "mpd_add_i64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "b",      c_type: "uint64_t",      erl_dir: "in",  erl_type: "uint64"}
      ],

      context: true
    },

    functions:
    [
      "mpd_add_u64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a",      c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "b",      c_type: "int64_t",       erl_dir: "in",  erl_type: "int64"            }
      ],

      context: true
    },

    functions:
    [
      "mpd_add_i64"
    ]
  },
  
  %{
    signature:
    %{
      return: %{          c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "q", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "a", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "b", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
    [
      "mpd_div",
      "mpd_divint"
    ]
  },
  
  %{
    signature:
    %{
      return: %{               c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "result", c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "base",   c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "exp",    c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
    [
      "mpd_pow"
    ]
  },
  
  %{
    signature:
    %{
      return: %{             c_type: "void",          erl_dir: "none"                               },

      parameters:
      [       
              %{name: "r",    c_type: "mpd_t**",       erl_dir: "out", erl_type: "resource_mpd_t_pp"},
              %{name: "base", c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"},
              %{name: "exp",  c_type: "const mpd_t**", erl_dir: "in",  erl_type: "resource_mpd_t_pp"}
      ],

      context: true
    },

    functions:
    [
      "mpd_rem",
      "mpd_rem_near"
    ]
  }
]

# TODO: Tests
# - All variable names in a function signature must be unique.
# - A return map with c_type: "void" has erl_dir: "none" and no other keys.
# - For resource parameters, the c_type and erl_type match.
# - Cannot have a return map with erl_dir: "out" and an argument map with erl_dir: "out"?
# - If multiple argument maps with erl_dir: "out" exist in the same signature, they each have a unique value for the :erl_tuple key?

defmodule NifGen do

  # Append to the last line in the list, if it exists.
  def append_to_last([], _) do
    []
  end

  def append_to_last(lines, string) when is_list(lines) and is_binary(string) do
    [last | other] = lines
                    |> List.flatten
                    |> Enum.reverse

    [last <> string | other] |> Enum.reverse
  end

  def call_function(%{c_type: "void"} = _return, function, args, false = _context) do
    ["#{function}(#{use_vars(args)});"]
  end
  
  def call_function( %{c_type: "void"} = _return, function, args, true = _context) do
    [
      "#{function}(#{use_vars(args)}, &ctx);",
      mpd_context_trap_check()
    ]
  end
  
  def call_function(return, function, args, false = _context) do
    ["#{use_var(return)} = #{function}(#{use_vars(args)});"]
  end
  
  def call_function(return, function, args, true = _context) do
    [
      "#{use_var(return)} = #{function}(#{use_vars(args)}, &ctx);",
      mpd_context_trap_check()
    ]
  end

  def check_args(args) do
    in_args = Enum.filter(args, &match?(%{erl_dir: "in"}, &1))
    in_argc = Enum.count(in_args) 
    case in_argc do
      0 ->
        [
          "if (argc != 0) {",
            "return enif_make_badarg(env);" |> indent,
          "}"
        ]
      _ ->
        [
          "if ((argc != #{in_argc}) ||",
               get_args(in_args) |> append_to_last(") {") |> indent(4),
            "return enif_make_badarg(env);" |> indent,
          "}"
        ]
    end
  end

  def create_resource(%{erl_dir: "out", erl_type: "resource_mpd_t_pp"} = arg) do
    [
      "error_term = create_resource_mpd_t_pp(env, &ctx, &#{use_var(arg)}, &#{use_term(arg)});",
      "if (enif_is_tuple(env, error_term)) {",
        "return error_term;" |> indent,
      "}"
    ]
  end

  def create_resource(%{erl_dir: "out"} = arg) do
    raise NifGenError, message: "Creation of Erlang resource not supported for: #{inspect(arg)}"
  end

  def create_resource(_) do
    []
  end

  def create_resources(args) do
    Enum.map(args, &create_resource(&1))
    |> separate_blocks
  end

  def declare_nif(function) do
    [nif_header(function) <> ";"]
  end

  def declare_nif_interface(libmpdec_interface) do
    Enum.reduce(libmpdec_interface, [], &(declare_nifs(&1) ++ &2))
    |> Enum.sort
    |> print
  end

  def declare_nifs(%{functions: functions}) do
    Enum.map(functions, &NifGen.declare_nif(&1))
  end

  def declare_term(%{erl_dir: "out"} = arg) do
    ["ERL_NIF_TERM #{use_term(arg)};"]
  end

  def declare_term(_) do
    []
  end

  def declare_terms(args) when is_list(args) do
    declared_terms = Enum.map(args, &declare_term(&1))
                     |> reject_empty_lists

    case (Enum.count(declared_terms)) do
      0 -> []
      _ -> declared_terms ++ ["ERL_NIF_TERM error_term;"]
    end
  end

  def declare_var(%{c_type: "void"}) do
    []
  end

  def declare_var(%{c_type: c_type, name: name}) do
    ["#{c_type} #{name};"]
  end

  def declare_var(var) do
    raise NifGenError, message: "Declaration of variable not supported for: #{inspect(var)}"
  end

  def declare_vars(vars) do
    Enum.map(vars, &declare_var(&1))
  end

  def define_nif(function, %{return: return, parameters: args, context: context}) do
    [
      nif_header(function),
      "{",
        [
          declare_vars([return | args]),
          declare_terms(args),
          check_args(args),
          init_context(context),
          create_resources(args),
          call_function(return, function, args, context),
          return([return | args])
        ]
        |> indent
        |> separate_blocks,
      "}"
    ]
  end

  def define_nif_interface(libmpdec_interface) do
    Enum.reduce(libmpdec_interface, [], &(define_nifs(&1) ++ &2))
    |> Enum.sort
    |> separate_blocks
    |> print
  end

  def define_nifs(%{functions: functions, signature: signature}) do
    Enum.map(functions, &NifGen.define_nif(&1, signature))
  end

  def delimit(list, delimiter) do
    list
    |> reject_empty_lists
    |> Enum.intersperse(delimiter)
    |> Enum.chunk_every(2)
    |> Enum.map(&Enum.join(&1))
  end

  def empty_list?(list) when is_list(list) do
    Enum.empty?(list)
  end

  def empty_list?(_) do
    false
  end

  def get_arg(%{erl_dir: "in", erl_type: "int64"} = arg, argn) do
    "enif_get_int64(env, argv[#{argn}], &#{use_var(arg)})"
  end
  
  def get_arg(%{erl_dir: "in", erl_type: "resource_mpd_t_pp"} = arg, argn) do
    "enif_get_resource(env, argv[#{argn}], RESOURCE_MPD_T_PP, (void**) &#{use_var(arg)})"
  end

  def get_arg(%{erl_dir: "in", erl_type: "uint64"} = arg, argn) do
    "enif_get_uint64(env, argv[#{argn}], &#{use_var(arg)})"
  end

  def get_arg(arg, _) do
    raise NifGenError, message: "Cannot get Erlang argument for: #{inspect(arg)}"
  end

  def get_args(args) do
    Enum.with_index(args, &("!" <> get_arg(&1, &2)))
    |> delimit(" ||")
  end

  def indent(lines, n \\ 4)
  
  # Recursively indent nested lists of lines.
  def indent(lines, n) when is_list(lines) do
    Enum.map(lines, &indent(&1, n))
  end

  # Don't indent empty lines.
  def indent("", _n) do
    []
  end

  def indent(line, n)  when is_binary(line) do
    String.duplicate(" ", n) <> line
  end
  
  def init_context(false = _context) do
    []
  end

  def init_context(true = _context) do
    ["mpd_context_t ctx = nif_copy_context(env);"]
  end

  def mpd_context_trap_check do
    [
      "if (ctx.newtrap) {",
        "return make_tuple_mpd_error(env, &ctx);" |> indent,
      "}"
    ]
  end

  def nif_header(function) do
    "ERL_NIF_TERM #{nif_name(function)}(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])"
  end

  def nif_name(function) do
    "nif__" <> function
  end

  def nif_registry(entries) do
    [
      "ErlNifFunc funcs[] = {",
        entries |> indent,
      "};"
    ]
  end

  def print(lines) do
    lines
    |> List.flatten
    |> NifGen.delimit("\n")
    |> IO.puts
  end

  def register_nif(function, %{parameters: parameters}) do
    arity = Enum.count(parameters, &match?(%{erl_dir: "in"}, &1))
    ["{\"#{function}\", #{arity}, #{NifGen.nif_name(function)}}"]
  end

  def register_nif_interface(libmpdec_interface) do
    Enum.reduce(libmpdec_interface, [], &(NifGen.register_nifs(&1) ++ &2))
    |> Enum.sort
    |> NifGen.delimit(",")
    |> NifGen.nif_registry
    |> NifGen.print
  end

  def register_nifs(%{functions: functions, signature: signature}) do
    Enum.map(functions, &NifGen.register_nif(&1, signature))
  end

  def reject_empty_lists(lines) when is_list(lines) do
    lines
    |> Enum.map(&reject_empty_lists(&1))
    |> Enum.reject(&empty_list?(&1))
  end

  def reject_empty_lists(line) do
    line
  end

  def return(vars) do
    out_vars = Enum.filter(vars, &match?(%{erl_dir: "out"}, &1)) 
    out_varc = Enum.count(out_vars)
    return_statement(out_vars, out_varc)
  end

  def return_statement(_, 0) do
    raise NifGenError, message: "Cannot generate return statement because no variables match %{erl_dir: \"out\"}"
  end

  def return_statement([var], 1) do
    ["return #{use_term(var)};"]
  end

  def return_statement(vars, varc) do
    ["return enif_make_tuple#{varc}(#{use_terms(vars)});"]
  end

  def separate_blocks(lines) when is_list(lines) do
    lines
    |> reject_empty_lists
    |> Enum.intersperse("")
  end

  def use_term(%{c_type: "int", erl_dir: "out", erl_type: "boolean"} = var) do
    "make_boolean(env, #{use_var(var)})"
  end

  def use_term(%{erl_dir: "out", name: name}) do
    "#{name}_term"
  end

  def use_terms(vars) do
    Enum.map(vars, &use_term(&1))
    |> delimit(", ")
    |> List.to_string
  end

  def use_var(%{erl_type: "resource_mpd_t_pp", name: name}) do
    "*" <> name
  end

  def use_var(%{name: name}) do
    name
  end
  
  def use_vars(vars) do
    Enum.map(vars, &use_var(&1))
    |> delimit(", ")
    |> List.to_string
  end

end

defmodule NifGenError do
  defexception message: "Error"
end

# TODO: Add script arguments to specify each of these functions individually.
# TODO: Generate Elixir function definitions.
NifGen.declare_nif_interface(libmpdec_interface)
IO.puts("")
NifGen.define_nif_interface(libmpdec_interface)
IO.puts("")
NifGen.register_nif_interface(libmpdec_interface)
IO.puts("")
