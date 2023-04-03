defmodule Stress do
  def generator(how_many) do
    float = (:rand.uniform_real() * 9.0) + 1.0
    dec = Decimal.from_float(float)
    receive do
      {:req, pid} ->
        case how_many do
          1 ->
            send pid, {:finished, dec}
          _other ->
            send pid, {:dec, dec}
            generator(how_many - 1)
        end
    end
  end

  def reporter(operator) do
    send operator, {:req, self()}
    receive do
      {:dec, dec} ->
        report_on(dec)
        reporter(operator)

      {:finished, dec} ->
        report_on(dec)
        IO.write(".")
    end
  end

  @one_hundred Decimal.new("100.0")
  @one Decimal.new("1.0")
  def report_on(decimal) do
    if Decimal.compare(decimal, @one) in [:gt, :eq] do
      if Decimal.compare(decimal, @one_hundred) in [:lt, :eq] do
        IO.write(".")
      else
        IO.puts "UNEXPECTED #{Decimal.to_string(decimal)}"
      end
    else
      IO.puts "UNEXPECTED #{Decimal.to_string(decimal)}"
    end
  end

  def operator(source, fun) do
    send source, {:req, self()}
    receive do
      {:dec, dec} ->
        dec = fun.(dec)
        receive do
          {:req, pid} ->
            send pid, {:dec, dec}
        end
        operator(source, fun)
      {:finished, dec} ->
        dec = fun.(dec)
        receive do
          {:req, pid} ->
            send pid, {:finished, dec}
        end
    end
  end
end

num_processes = 500
numbers_per_process = 40_000

two = Decimal.new("2.0")
square_fn = fn dec -> MPDecimal.power(dec, two) end
exp_fn = fn dec -> MPDecimal.exp(dec) end
ln_fn = fn dec -> MPDecimal.ln(dec) end

(1..num_processes)
|> Enum.map(fn _ ->
  generator = spawn(fn -> Stress.generator(numbers_per_process) end)
  squarer = spawn(fn -> Stress.operator(generator, square_fn) end)
  exper = spawn(fn -> Stress.operator(squarer, exp_fn) end)
  lner = spawn(fn -> Stress.operator(exper, ln_fn) end)
  Task.async(fn -> Stress.reporter(lner) end)
end)
|> Enum.map(& Task.await(&1, 60 * 60_000))
IO.puts "processes started"
