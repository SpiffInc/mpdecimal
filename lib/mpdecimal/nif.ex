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

  def power(_base, _power) do
    raise "NIF power/2 not implemented"
  end

  def zero do
    raise "NIF zero/0 not implemented"
  end
end
