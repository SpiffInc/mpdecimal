defmodule MPDecimal.Nif do
  @moduledoc false
  @on_load :init

  def init do
    case load_nifs() do
      :ok ->
        :ok

      _ ->
        raise """
        An error occured when loading the mpdecimal nif
        """
    end
  end

  def load_nifs do
    path = :filename.join(:code.priv_dir(:mpdecimal), 'mpdecimal_nif')
    :erlang.load_nif(path, 0)
  end

  def new(b) when is_binary(b) do
    # TODO: Reconcile with other comment.
    # Add the null terminator.
    set_string(b <> "\0")
  end

  # def new(num) when is_integer(num) do
    
  # end

  # MPDecimal library functions with common wrapper logic.
  # (i.e.) always allocate a new result variable to make it fit the functional paradigm.
  def abs(_a), do: raise "abs/1 not implemented"
  def add(_a, _b), do: raise "add/2 not implemented"

  # and is a reserved word in Elixir
  # def and(_a, _b), do: raise "and/2 not implemented"
  
  def canonical(_a), do: raise "canonical/1 not implemented"
  def ceil(_a), do: raise "ceil/1 not implemented"
  def check_nan(_a), do: raise "check_nan/1 not implemented"
  def check_nans(_a, _b), do: raise "check_nans/2 not implemented"
  def compare(_a, _b), do: raise "compare/2 not implemented"
  def compare_signal(_a, _b), do: raise "compare_signal/2 not implemented"
  def copy(_a), do: raise "copy/1 not implemented"
  def copy_abs(_a), do: raise "copy_abs/1 not implemented"
  def copy_negate(_a), do: raise "copy_negate/1 not implemented"
  def copy_sign(_a, _b), do: raise "copy_sign/2 not implemented"
  def div(_a, _b), do: raise "div/2 not implemented"
  def divint(_a, _b), do: raise "divint/2 not implemented"
  def divmod(_a, _b), do: raise "divmod/2 not implemented"
  def exp(_a), do: raise "exp/1 not implemented"
  def floor(_a), do: raise "floor/1 not implemented"
  def fma(_a, _b, _c), do: raise "fma/3 not implemented"
  def invert(_a), do: raise "invert/1 not implemented"
  def invroot(_a), do: raise "invroot/1 not implemented"
  def ln(_a), do: raise "ln/1 not implemented"
  def log10(_a), do: raise "log10/1 not implemented"
  def logb(_a), do: raise "logb/1 not implemented"
  def max(_a, _b), do: raise "max/2 not implemented"
  def max_mag(_a, _b), do: raise "max_mag/2 not implemented"
  def min(_a, _b), do: raise "min/2 not implemented"
  def min_mag(_a, _b), do: raise "min_mag/2 not implemented"
  def minus(_a), do: raise "minus/1 not implemented"
  def mul(_a, _b), do: raise "mul/2 not implemented"
  def next_minus(_a), do: raise "next_minus/1 not implemented"
  def next_plus(_a), do: raise "next_plus/1 not implemented"
  def next_toward(_a, _b), do: raise "next_toward/2 not implemented"
  
  # or is a reserved word in Elixir
  # def or(_a, _b), do: raise "or/2 not implemented"
  
  def plus(_a), do: raise "plus/1 not implemented"
  def pow(_base, _exp), do: raise "pow/2 not implemented"
  def powmod(_base, _exp, _mod), do: raise "powmod/3 not implemented"
  def quantize(_a, _b), do: raise "quantize/2 not implemented"
  def reduce(_a), do: raise "reduce/1 not implemented"
  def rem(_a, _b), do: raise "rem/2 not implemented"
  def rem_near(_a, _b), do: raise "rem_near/2 not implemented"
  def rotate(_a, _b), do: raise "rotate/2 not implemented"
  def round_to_int(_a), do: raise "round_to_int/1 not implemented"
  def round_to_intx(_a), do: raise "round_to_intx/1 not implemented"
  def scaleb(_a, _b), do: raise "scaleb/2 not implemented"
  def shift(_a, _b), do: raise "shift/2 not implemented"
  def sqrt(_a), do: raise "sqrt/1 not implemented"
  def sub(_a, _b), do: raise "sub/2 not implemented"
  def trunc(_a), do: raise "trunc/1 not implemented"
  def xor(_a, _b), do: raise "xor/2 not implemented"

  # TODO: Not officially part of the API.
  # Custom NIF functions.
  def set_string(_s), do: raise "set_string/1 not implemented"
  def to_string(_a), do: raise "to_string/1 not implemented"

end
