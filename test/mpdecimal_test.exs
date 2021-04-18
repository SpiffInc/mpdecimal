defmodule MPDecimalTest do
  use ExUnit.Case
  doctest MPDecimal

  test "zero" do
    assert MPDecimal.zero() == 42
  end
end
