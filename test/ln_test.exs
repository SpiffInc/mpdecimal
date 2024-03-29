defmodule LnTest do
  use ExUnit.Case

  test "positive integer exponents" do
    assert_ln(1, "0")
    assert_ln(2, "0.6931471805599453094172321215")
    assert_ln(256, "5.545177444479562475337856972")
  end

  test "decimal input values" do
    assert_ln("0.5", "-0.6931471805599453094172321215")
    assert_ln("1.5", "0.4054651081081643819780131155")
    assert_ln("3.2343245", "1.173820096257234794026330732")
    assert_ln("1000.2443", "6.907999549145751305830408424")
  end

  test "infinity cases" do
    assert_ln(0, "-Infinity")
    assert_ln("0.0", "-Infinity")
    assert_ln("Infinity", "Infinity")
  end

  test "error cases" do
    assert_ln_error("-2", "[IEEE_Invalid_operation]")
    assert_ln_error(-2, "[IEEE_Invalid_operation]")
    assert_ln_error("-1.43434", "[IEEE_Invalid_operation]")
    assert_ln_error("-Infinity", "[IEEE_Invalid_operation]")
  end

  defp assert_ln(input, expected_value) do
    assert result = MPDecimal.ln(Decimal.new(input))
    assert Decimal.eq?(result, Decimal.new(expected_value))
  end

  defp assert_ln_error(input, error_message) do
    assert_raise(MPDecimal.Error, error_message, fn ->
      MPDecimal.ln(Decimal.new(input))
    end)
  end
end
