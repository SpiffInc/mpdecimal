defmodule PowerTest do
  use ExUnit.Case

  test "positive integer exponents" do
    assert_power(2, 2, "4.0")
    assert_power(2, 3, "8.0")
    assert_power(1, 8, "1.0")
    assert_power(2, 8, "256.0")
    assert_power(2, 0, "1.0")
    assert_power(256, 0, "1.0")
  end

  test "negative integer exponents" do
    assert_power(-1, 2, "1.0")
    assert_power(-2, 3, "-8.0")
    assert_power(-1, 0, "1.0")
    assert_power(-1, -1, "-1.0")
    assert_power(-2, -2, "0.25")
  end

  test "handling zero base values" do
    assert_power(0, 1, "0.0")
    assert_power(0, 2, "0.0")

    assert_power("0", 1, "0.0")
    assert_power("0", 2, "0.0")
  end

  test "decimal base values with integer powers" do
    assert_power("0.5", 2, "0.25")
    assert_power("0.5", 0, "1")
    assert_power("0.5", -1, "2")
    assert_power("0.5", -2, "4")
    assert_power("-0.5", 2, "0.25")
    assert_power("-0.5", 3, "-0.125")
    assert_power("-0.5", 0, "1")
    assert_power("-0.5", -1, "-2")
    assert_power("-0.5", -2, "4")
    assert_power("-0.5", -3, "-8")
  end

  test "integer base values with decimal powers" do
    assert_power(2, "2.5", "5.656854249492380195206754897")
    assert_power(2, "1.75", "3.363585661014858172124501905")
    assert_power(2, "0.9", "1.866065983073614831962686532")
    assert_power(2, "0.5", "1.414213562373095048801688724")
    assert_power(2, "0", "1")
    assert_power(2, "-0.5", "0.7071067811865475244008443621")
    assert_power(2, "-1.5", "0.3535533905932737622004221811")
    assert_power(0, "2.5", "0")
    assert_power(0, "1.75", "0")
    assert_power(0, "0.9", "0")
    assert_power(0, "0.5", "0")
  end

  test "infinity cases" do
    assert_power(0, -1, "Infinity")
    assert_power("0.0", "-0.5", "Infinity")
    assert_power("Infinity", 0, 1)
    assert_power(1, "Infinity", 1)
    assert_power(2, "Infinity", "Infinity")
    assert_power("-Infinity", 0, 1)
    assert_power(1, "-Infinity", 1)
    assert_power(2, "-Infinity", "0")
  end

  test "error cases" do
    assert_power_error("0", "0", "[IEEE_Invalid_operation]")
    assert_power_error("-2", "2.5", "[IEEE_Invalid_operation]")
    assert_power_error("-2", "0.9", "[IEEE_Invalid_operation]")
    assert_power_error("-2", "-1.5", "[IEEE_Invalid_operation]")
  end

  defp assert_power(base, power, expected_value) do
    assert result = MPDecimal.power(Decimal.new(base), Decimal.new(power))
    assert Decimal.eq?(result, Decimal.new(expected_value))
  end

  defp assert_power_error(base, power, error_message) do
    assert_raise(MPDecimal.Error, error_message, fn ->
      MPDecimal.power(Decimal.new(base), Decimal.new(power))
    end)
  end
end
