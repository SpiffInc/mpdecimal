value0 = Decimal.new("0.1234567890123456789012345")
value1 = Decimal.new("0.5")
value2 =  Decimal.new("4.0")
value3 = Decimal.new("123456.1234567890123456")
value4 =  Decimal.new("1234567890.1234567890123456")


Benchee.run(
  %{
    "Decimal.sqrt(\"4.0\")" => fn -> Decimal.sqrt(value2) end,
    "Decimal.sqrt(\"1234567890.1234567890123456\")" => fn -> Decimal.sqrt(value4) end,
    "MPDecimal.power(\"4.0\",\"0.5\")" => fn -> MPDecimal.power(value2, value1) end,
    "MPDecimal.power(\"1234567890.1234567890123456\",\"0.5\")" => fn -> MPDecimal.power(value4, value1) end,
    "MPDecimal.power(\"1234567890.1234567890123456\",\"0.1234567890123456789012345\")" => fn -> MPDecimal.power(value4, value0) end,
    "MPDecimal.ln(\"4.0\")" => fn -> MPDecimal.ln(value2) end,
    "MPDecimal.ln(\"123456.1234567890123456\")" => fn -> MPDecimal.ln(value3) end,
    "MPDecimal.exp(\"4.0\")" => fn -> MPDecimal.exp(value2) end,
    "MPDecimal.exp(\"123456.1234567890123456\")" => fn -> MPDecimal.exp(value3) end
  },
  warmup: 1,
  time: 2 
)
