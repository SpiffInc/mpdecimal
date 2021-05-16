defmodule MPDecimal do
  alias MPDecimal.Nif

  def power(%Decimal{} = base, %Decimal{} = power) do
    base = Decimal.to_string(base, :xsd)
    power = Decimal.to_string(power, :xsd)
    res = Nif.power(base, power)
    Decimal.new(res)
  end
end
