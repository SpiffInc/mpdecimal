defmodule MPDecimal do
  alias MPDecimal.Nif

  def power(%Decimal{} = base, %Decimal{} = exponent) do
    # Add the null terminator to the end of each string argument so that it
    # forms a valid cstring for consumption by the NIF.
    base = Decimal.to_string(base, :xsd) <> "\0"
    exponent = Decimal.to_string(exponent, :xsd) <> "\0"
    
    case Nif.power(base, exponent) do
      {:ok, result} -> Decimal.new(result)
      {:error, message} -> raise(MPDecimal.Error, message: message)
    end
  end
end

defmodule MPDecimal.Error do
  defexception [:message]
end
