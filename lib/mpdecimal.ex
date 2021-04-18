defmodule MPDecimal do
  @on_load :load_nifs

  def load_nifs do
    path = :filename.join(:code.priv_dir(:mpdecimal), 'mpdecimal_nif')
    :erlang.load_nif(path, 0)
  end

  def mpdecimal_zero do
    raise "NIF mpdecimal_zero/0 not implemented"
  end
end
