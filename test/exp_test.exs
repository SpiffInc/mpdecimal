defmodule ExpTest do
  use ExUnit.Case
  doctest MPDecimal

  test "positive integer exponents" do
    assert_exp(1, "2.718281828459045235360287471")
    assert_exp(2, "7.389056098930650227230427461")
    assert_exp(256, "1.511427665004103542520089666E+111")
  end

  test "decimal input values" do
    assert_exp("0.5", "1.648721270700128146848650788")
    assert_exp("1.5", "4.481689070338064822602055460")
    assert_exp("3.2343245", "25.38921556987368219580508094")
    assert_exp("1000.2443", "2.515243556929138377098384013E+434")
  end

  test "zero cases" do
    assert_exp(0, "1")
  end

  test "infinity cases" do
    assert_exp("-Infinity", 0)
    assert_exp("Infinity", "Infinity")
  end

  defp assert_exp(input, expected_value) do
    assert result = MPDecimal.exp(Decimal.new(input))
    assert Decimal.eq?(result, Decimal.new(expected_value))
  end
end
