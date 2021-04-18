defmodule MPDecimal do
  defdelegate zero, to: MPDecimal.Nif
end
