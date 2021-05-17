base0 =  Decimal.new("4.0")
power0 = Decimal.new("0.5")

base1 =  Decimal.new("1234567890.1234567890123456")
power1 = Decimal.new("0.1234567890123456789012345")

Benchee.run(
  %{
    "Decimal.sqrt(\"4.0\")" => fn -> Decimal.sqrt(base0) end,
    "Decimal.sqrt(\"1234567890.1234567890123456\")" => fn -> Decimal.sqrt(base1) end,
    "MPDecimal.power(\"4.0\",\"0.5\")" => fn -> MPDecimal.power(base0, power0) end,
    "MPDecimal.power(\"1234567890.1234567890123456\",\"0.5\")" => fn -> MPDecimal.power(base1, power0) end,
    "MPDecimal.power(\"1234567890.1234567890123456\",\"0.1234567890123456789012345\")" => fn -> MPDecimal.power(base1, power1) end
    
  },
  warmup: 1,
  time: 2 
)
