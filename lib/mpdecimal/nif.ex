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

  # TODO: Documentation
  # MPDecimal library functions with common wrapper logic.
  # (i.e.) always allocate a new result variable to make it fit the functional paradigm.
  def _abs(_a), do: raise "_abs/1 not implemented"
  def _add(_a, _b), do: raise "_add/2 not implemented"
  def _and(_a, _b), do: raise "_and/2 not implemented"
  def _canonical(_a), do: raise "_canonical/1 not implemented"
  def _ceil(_a), do: raise "_ceil/1 not implemented"
  def _check_nan(_a), do: raise "_check_nan/1 not implemented"
  def _check_nans(_a, _b), do: raise "_check_nans/2 not implemented"
  def _cmp(_a, _b), do: raise "_cmp/2 not implemented"
  def _compare(_a, _b), do: raise "_compare/2 not implemented"
  def _compare_signal(_a, _b), do: raise "_compare_signal/2 not implemented"
  def _compare_total(_a, _b), do: raise "_compare_total/2 not implemented"
  def _compare_total_mag(_a, _b), do: raise "_compare_total_mag/2 not implemented"
  def _copy(_a), do: raise "_copy/1 not implemented"
  def _copy_abs(_a), do: raise "_copy_abs/1 not implemented"
  def _copy_negate(_a), do: raise "_copy_negate/1 not implemented"
  def _copy_sign(_a, _b), do: raise "_copy_sign/2 not implemented"
  def _div(_a, _b), do: raise "_div/2 not implemented"
  def _divint(_a, _b), do: raise "_divint/2 not implemented"
  def _divmod(_a, _b), do: raise "_divmod/2 not implemented"
  def _exp(_a), do: raise "_exp/1 not implemented"
  def _floor(_a), do: raise "_floor/1 not implemented"
  def _fma(_a, _b, _c), do: raise "_fma/3 not implemented"
  def _invert(_a), do: raise "_invert/1 not implemented"
  def _invroot(_a), do: raise "_invroot/1 not implemented"
  def _isinfinite(_a), do: raise "_isinfinite/1 not implemented"
  def _isinteger(_a), do: raise "_isinteger/1 not implemented"
  def _isnan(_a), do: raise "_isnan/1 not implemented"
  def _ispositive(_a), do: raise "_ispositive/1 not implemented"
  def _ln(_a), do: raise "_ln/1 not implemented"
  def _log10(_a), do: raise "_log10/1 not implemented"
  def _logb(_a), do: raise "_logb/1 not implemented"
  def _max(_a, _b), do: raise "_max/2 not implemented"
  def _max_mag(_a, _b), do: raise "_max_mag/2 not implemented"
  def _min(_a, _b), do: raise "_min/2 not implemented"
  def _min_mag(_a, _b), do: raise "_min_mag/2 not implemented"
  def _minus(_a), do: raise "_minus/1 not implemented"
  def _mul(_a, _b), do: raise "_mul/2 not implemented"
  def _next_minus(_a), do: raise "_next_minus/1 not implemented"
  def _next_plus(_a), do: raise "_next_plus/1 not implemented"
  def _next_toward(_a, _b), do: raise "_next_toward/2 not implemented"
  def _or(_a, _b), do: raise "_or/2 not implemented"
  def _plus(_a), do: raise "_plus/1 not implemented"
  def _pow(_base, _exp), do: raise "_pow/2 not implemented"
  def _powmod(_base, _exp, _mod), do: raise "_powmod/3 not implemented"
  def _quantize(_a, _b), do: raise "_quantize/2 not implemented"
  def _reduce(_a), do: raise "_reduce/1 not implemented"
  def _rem(_a, _b), do: raise "_rem/2 not implemented"
  def _rem_near(_a, _b), do: raise "_rem_near/2 not implemented"
  def _rotate(_a, _b), do: raise "_rotate/2 not implemented"
  def _round_to_int(_a), do: raise "_round_to_int/1 not implemented"
  def _round_to_intx(_a), do: raise "_round_to_intx/1 not implemented"
  def _scaleb(_a, _b), do: raise "_scaleb/2 not implemented"
  def _shift(_a, _b), do: raise "_shift/2 not implemented"
  def _sqrt(_a), do: raise "_sqrt/1 not implemented"
  def _sub(_a, _b), do: raise "_sub/2 not implemented"
  def _trunc(_a), do: raise "_trunc/1 not implemented"
  def _xor(_a, _b), do: raise "_xor/2 not implemented"

  def _set_i64(_a), do: raise "_set_i64/1 not implemented"
  def _set_string(_s), do: raise "_set_string/1 not implemented"
  def _to_eng(_a), do: raise "_to_sci/1 not implemented"
  def _to_sci(_a), do: raise "_to_eng/1 not implemented"

  # TODO: Is this actually needed?
  # Not an mpdecimal library function.
  def _is_mpdecimal(_a), do: raise "_is_mpdecimal/1 not implemented"
end
