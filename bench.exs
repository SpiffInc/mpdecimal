Benchee.run(
  %{
    "2 ^ 2" => fn -> MPDecimal.Nif.power("2", "2") end,
    "2.0 ^ 2.0" => fn -> MPDecimal.Nif.power("2.0", "2.0") end,
    "3.14159 ^ 1.58732" => fn -> MPDecimal.Nif.power("3.14159", "1.58732") end
  }
)
