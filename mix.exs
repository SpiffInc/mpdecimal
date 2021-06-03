defmodule Mpdecimal.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/SpiffInc/mpdecimal"

  def project do
    [
      app: :mpdecimal,
      compilers: [:elixir_make] ++ Mix.compilers(),
      make_targets: ["all"],
      make_clean: ["clean"],
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: [
        main: "readme",
        source_ref: "v#{@version}",
        source_url: @source_url,
        extras: ["README.md"]
      ]
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

      {:ex_doc, "~> 0.24.2", only: :dev},
      {:benchee, "~> 1.0", only: :dev}
    ]
  end

  defp package do
    [
      description: "Provide fixed-decimal precision math as a NIF",
      files: [
        "lib",
        "priv",
        ".formatter.exs",
        "mix.exs",
        "README*",
        "LICENSE*",
        "CHANGELOG*",
        "Makefile",
        "c_lib",
        "c_src"
      ],
      name: "mpdecimal",
      licenses: ["MIT"],
      links: %{"github" => @source_url},
      maintainers: [
        "Jonner Steck",
        "Michael Ries"
      ]
    ]
  end
end
