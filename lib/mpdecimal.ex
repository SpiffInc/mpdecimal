defmodule MPDecimal do
  alias MPDecimal.Nif

  @doc """
  raise a decimal to a power

  This function performs exponentiation with fixed-decimal precision.

  ## Examples

      iex> two = Decimal.new("2.0")
      #Decimal<2.0>
      iex> four = MPDecimal.power(two, two)
      #Decimal<4.00>
      iex> MPDecimal.power(four, Decimal.new("0.5"))
      #Decimal<2.000000000000000000000000000>
  """
  def exp(%Decimal{} = input) do
    # Add the null terminator to the end of each string argument so that it
    # forms a valid cstring for consumption by the NIF.
    if :gt == Decimal.compare(input, 1_000_000) && Decimal.new("Infinity") != input do
      raise(MPDecimal.Error,
        message:
          "This function is defined for inputs >= -1000000 and <= 1000000 and where the input is +/-Infinity."
      )
    end

    input = Decimal.to_string(input, :xsd) <> "\0"

    case Nif.exp(input) do
      {:ok, result} -> Decimal.new(result)
      {:error, message} -> raise(MPDecimal.Error, message: message)
    end
  end

  def ln(%Decimal{} = input) do
    # Add the null terminator to the end of each string argument so that it
    # forms a valid cstring for consumption by the NIF.
    input = Decimal.to_string(input, :xsd) <> "\0"

    case Nif.ln(input) do
      {:ok, result} -> Decimal.new(result)
      {:error, message} -> raise(MPDecimal.Error, message: message)
    end
  end

  def power(%Decimal{} = base, %Decimal{} = exponent) do
    if (:lt == Decimal.compare(exponent, -10_000) || :gt == Decimal.compare(exponent, 10_000)) &&
         Decimal.new("Infinity") != exponent do
      raise(MPDecimal.Error,
        message:
          "This function is defined x ^ y where y >= -10000 and <= 1E-10000 and where y = +/-Infinity."
      )
    end

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
