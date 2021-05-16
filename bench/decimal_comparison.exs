two = Decimal.new("2.0")

Benchee.run(
  %{
    "2.0 + 2.0" => fn -> Decimal.add(two, two) end,
    "2.0 * 2.0" => fn -> Decimal.mult(two, two) end,
    "2.0 ^ 2.0" => fn -> MPDecimal.power(two, two) end
  },
  warmup: 1,
  time: 2
)
