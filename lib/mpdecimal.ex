defmodule MPDecimal do
  import Kernel, except: [abs: 1, div: 2, max: 2, min: 2, rem: 2]
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
#  def power(%Decimal{} = base, %Decimal{} = exponent) do
#    # Add the null terminator to the end of each string argument so that it
#    # forms a valid cstring for consumption by the NIF.
#    base = Decimal.to_string(base, :xsd) <> "\0"
#    exponent = Decimal.to_string(exponent, :xsd) <> "\0"
#
#    case Nif._pow(base, exponent) do
#      {:ok, result} -> Decimal.new(result)
#      {:error, message} -> raise(MPDecimal.Error, message: message)
#    end
#  end

  # TODO
  # defp is_reference(term) when is_reference(term), do: Nif._is_reference(term)
  # defp is_reference(term), do: false

  # TODO
  # Store context in process dictionary.

  def abs(a) when is_reference(a), do: Nif._abs(a)
  def abs(a), do: abs(mpdecimal(a))

  def add(a, b) when is_reference(a) and is_reference(b), do: Nif._add(a, b)
  def add(a, b), do: add(mpdecimal(a), mpdecimal(b))

  # TODO
  # def apply_context

  # TODO
  # def cast
  # Need to be able to work with floating-point numbers.

  def compare(a, b) when is_reference(a) and is_reference(b) do
    result = Nif._cmp(a, b)
    cond do
      result === 0 -> :eq
      result  >  0 -> :gt
      result  <  0 -> :lt
    end 
  end

  def compare(a, b), do: compare(mpdecimal(a), mpdecimal(b))

  def cmp(a, b), do: compare(a, b)

  def div(a, b) when is_reference(a) and is_reference(b), do: Nif._div(a, b)
  def div(a, b), do: div(mpdecimal(a), mpdecimal(b))

  def div_int(a, b) when is_reference(a) and is_reference(b), do: Nif._divint(a, b)
  def div_int(a, b), do: div_int(mpdecimal(a), mpdecimal(b))

  def div_rem(a, b) when is_reference(a) and is_reference(b), do: Nif._divmod(a, b)
  def div_rem(a, b), do: div_rem(mpdecimal(a), mpdecimal(b))

  def eq?(a, b) when is_reference(a) and is_reference(b) do
    compare(a, b) == :eq
  end

  def eq?(a, b), do: eq?(mpdecimal(a), mpdecimal(b))
  
  def equal?(a, b), do: eq?(a, b)

  # TODO
  # def from_float(a)

  def gt?(a, b) when is_reference(a) and is_reference(b) do
    compare(a, b) == :gt
  end

  def gt?(a, b), do: gt?(mpdecimal(a), mpdecimal(b))

  def inf?(a) when is_reference(a), do: Nif._isinfinite(a)
  def inf?(a), do: inf?(mpdecimal(a))

  def integer?(a) when is_reference(a), do: Nif._isinteger(a)
  def integer?(a), do: integer?(mpdecimal(a))

  def lt?(a, b) when is_reference(a) and is_reference(b) do
    compare(a, b) == :lt
  end

  def lt?(a, b), do: lt?(mpdecimal(a), mpdecimal(b))

  def max(a, b) when is_reference(a) and is_reference(b), do: Nif._max(a, b)
  def max(a, b), do: max(mpdecimal(a), mpdecimal(b))

  def min(a, b) when is_reference(a) and is_reference(b), do: Nif._min(a, b)
  def min(a, b), do: min(mpdecimal(a), mpdecimal(b))

  def mult(a, b) when is_reference(a) and is_reference(b), do: Nif._mul(a, b)
  def mult(a, b), do: mult(mpdecimal(a), mpdecimal(b))

  def nan?(a) when is_reference(a), do: Nif._isnan(a)
  def nan?(a), do: nan?(mpdecimal(a))
  
  def negate(a) when is_reference(a), do: Nif._minus(a)
  def negate(a), do: negate(mpdecimal(a))

  def new(binary) when is_binary(binary) do
    # Add the null terminator to the end of the string argument so that it
    # forms a valid cstring for consumption by the NIF.
    Nif._set_string(binary <> "\0")
  end

  def new(integer) when is_integer(integer), do: Nif._set_i64(integer)
  def new(mpdecimal) when is_reference(mpdecimal), do: Nif._copy(mpdecimal)

  def new(%Decimal{} = decimal) do
    new(Decimal.to_string(decimal))
  end

  # TODO
  # def new(sign, coefficient, exponent)
  
  def normalize(a) when is_reference(a), do: Nif._reduce(a)
  def normalize(a), do: normalize(mpdecimal(a))

  # TODO
  # def parse

  def positive?(a) when is_reference(a), do: Nif._ispositive(a)
  def positive?(a), do: positive?(mpdecimal(a))
  
  def rem(a, b) when is_reference(a) and is_reference(b), do: Nif._rem(a, b)
  def rem(a, b), do: rem(mpdecimal(a), mpdecimal(b))

  # TODO
  # def round/1
  # def round/2
  # def round/3
  
  def sqrt(a) when is_reference(a), do: Nif._sqrt(a)
  def sqrt(a), do: sqrt(mpdecimal(a))

  def sub(a, b) when is_reference(a) and is_reference(b), do: Nif._sub(a, b)
  def sub(a, b), do: sub(mpdecimal(a), mpdecimal(b))

  # TODO
  # def to_float

  def pow(a, b) when is_reference(a) and is_reference(b), do: Nif._pow(a, b)
  def pow(a, b), do: pow(mpdecimal(a), mpdecimal(b))

  def to_string(mpdecimal) when is_reference(mpdecimal) do
    Nif._to_sci(mpdecimal)
  end

  defp mpdecimal(binary) when is_binary(binary), do: new(binary)
  defp mpdecimal(integer) when is_integer(integer), do: new(integer)
  defp mpdecimal(mpdecimal) when is_reference(mpdecimal), do: mpdecimal
  defp mpdecimal(%Decimal{} = decimal), do: new(decimal)

  defp mpdecimal(other) when is_float(other) do
    raise ArgumentError,
          "implicit conversion of #{inspect(other)} to MPDecimal is not allowed. Use MPDecimal.from_float/1"
  end

  # TODO
  # def from_Decimal()
  # def to_Decimal()
  #   Decimal.parse

end

defmodule MPDecimal.Error do
  defexception [:message]
end

# TODO
# Use an MPDecimal struct to contain the reference?
defimpl Inspect, for: Reference do
  require MPDecimal

  def inspect(mpdecimal, _opts) do
    "#MPDecimal<" <> MPDecimal.to_string(mpdecimal) <> ">"
  end
end
