defmodule MPDecimal.NifTest do
  use ExUnit.Case, async: true

  test "non-string args do not crash the VM" do
    assert_raise ArgumentError, fn ->
      MPDecimal.Nif.power("12.34", nil)
    end

    assert_raise ArgumentError, fn ->
      MPDecimal.Nif.power(false, "12.34")
    end

    assert_raise ArgumentError, fn ->
      MPDecimal.Nif.power(12, 34)
    end
  end

  test "non-numeric strings do not crash the VM" do
    assert MPDecimal.Nif.power("foo", "bar") == {:error, "[IEEE_Invalid_operation]"}

    assert MPDecimal.Nif.power("2.0", "0.1a") == {:error, "[IEEE_Invalid_operation]"}
  end
end
