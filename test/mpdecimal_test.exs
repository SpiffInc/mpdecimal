defmodule MPDecimalTest do
  use ExUnit.Case
  doctest MPDecimal

  test "correct digit handling" do
    result = MPDecimal.Nif.power("3.14159", "1.58732")
    assert result == "6.153686306332765322891030633"
  end

  test "Strange NaN behavior???" do
    result = MPDecimal.Nif.power("3.1", "1.587321")
    assert result == "6.1536933506402224364507308462"
  end

  test "bad args do not crash the VM" do
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
end
