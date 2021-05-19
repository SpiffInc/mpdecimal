defmodule MPDecimal do
  alias MPDecimal.Nif

  def power(%Decimal{} = base, %Decimal{} = exponent) do
    # Add the null terminator to the end of each string argument so that it
    # forms a valid cstring for consumption by the NIF.
    base = Decimal.to_string(base, :xsd) <> "\0"
    exponent = Decimal.to_string(exponent, :xsd) <> "\0"
    result = Nif.power(base, exponent)
    Decimal.new(result)
  end
end
