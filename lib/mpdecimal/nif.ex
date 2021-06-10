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
  
  def new(), do: raise "new/0 not implemented"
  def pow(_a, _b), do: raise "pow/2 not implemented"

end
