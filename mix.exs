defmodule Mpdecimal.MixProject do
  use Mix.Project

  def project do
    [
      app: :mpdecimal,
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_targets: ["all"],
      make_clean: ["clean"],
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:decimal, "~> 2.0"},
      {:elixir_make, "~> 0.6", runtime: false},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end
end
