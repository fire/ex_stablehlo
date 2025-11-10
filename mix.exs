defmodule ExMLIR.MixProject do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/yourusername/ex_mlir"

  def project do
    [
      app: :ex_mlir,
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      docs: [
        main: "ExMLIR",
        extras: ["README.md"]
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nx, "~> 0.6"},
      {:axon, "~> 0.6"},
      {:sourceror, "~> 1.10"},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end

  defp description do
    "A library for converting MLIR to Elixir Nx and Axon, supporting arith, scf, memref, and func dialects"
  end

  defp package do
    [
      maintainers: ["Your Name"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end

