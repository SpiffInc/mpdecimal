defmodule Stress do
  def reporter do
    receive do
      {:decimal, _dec} ->
        IO.write(".")
        reporter()
    end
  end

  # takes in numbers beteeen 1.0 and 10.0 and squares them
  # producing numbers between 1.0 and 100.0
  @two Decimal.new("2.0")
  def squarer(reporters) do
    receive do
      {:decimal, dec} ->
        result = MPDecimal.power(dec, @two)
        [reporter] = Enum.take_random(reporters, 1)
        Process.send(reporter, {:decimal, result}, [])
        squarer(reporters)
    end
  end

  # takes in numbers betwen 0.0 and 2.303... and produces
  # numbers between 1.0 and 10.0
  def expers(squarers) do
    receive do
      {:decimal, dec} ->
        result = MPDecimal.exp(dec)
        [squarer] = Enum.take_random(squarers, 1)
        Process.send(squarer, {:decimal, result}, [])
        expers(squarers)
    end
  end

  # takes in numbers between 1.0 and 10.0 and produces
  # numbers between 0 and 2.303...
  def lners(expers) do
    receive do
      {:decimal, dec} ->
        result = MPDecimal.ln(dec)
        [exper] = Enum.take_random(expers, 1)
        Process.send(exper, {:decimal, result}, [])
        lners(expers)
    end
  end

  # sends decimal numbers with values between 1.0 and 10.0
  def feed(lners, decimals_per_process) do
    lners
    |> Enum.map(fn pid ->
      Task.async(fn ->
        (1..decimals_per_process) |> Enum.each(fn _ ->
          float = (:rand.uniform_real() * 9.0) + 1.0
          dec = Decimal.from_float(float)
          Process.send(pid, {:decimal, dec}, [])
        end)
      end)
    end)
    |> Enum.map(fn task -> Task.await(task, 600_000) end)
  end
end



reporters = Enum.map(1..1_000, fn(_i) ->
  spawn(&Stress.reporter/0)
end)

squarers = Enum.map(1..1_000, fn(_i) ->
  spawn(fn ->
    Stress.squarer(reporters)
  end)
end)

expers = Enum.map(1..1_000, fn(_i) ->
  spawn(fn ->
    Stress.squarer(squarers)
  end)
end)

lners = Enum.map(1..1_000, fn(_i) ->
  spawn(fn ->
    Stress.squarer(expers)
  end)
end)
IO.puts "processes started"

Stress.feed(lners, 10_000)
IO.puts "processes have been fed"
