#!/usr/bin/env elixir

# Script to run MLIR to Axon and Elixir to MLIR conversion examples

Mix.install([
  {:nx, "~> 0.6"},
  {:axon, "~> 0.6"},
  {:sourceror, "~> 1.10"}
])

# Load all example modules
Code.require_file("lib/ex_mlir.ex")
Code.require_file("examples/mlir_to_axon.ex")
Code.require_file("examples/elixir_to_mlir.ex")
Code.require_file("examples/axon_models.ex")

IO.puts("=" <> String.duplicate("=", 70))
IO.puts("ExMLIR - MLIR to Axon and Elixir to MLIR Examples")
IO.puts("=" <> String.duplicate("=", 70))
IO.puts()

# MLIR to Axon Examples
IO.puts("\n[MLIR to Axon Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Addition")
{mlir, _axon} = ExMLIR.Examples.MLIRToAxon.example_simple_add()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n2. Dense Layer")
{mlir, _axon} = ExMLIR.Examples.MLIRToAxon.example_dense_layer()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n3. Convolution Layer")
{mlir, _axon} = ExMLIR.Examples.MLIRToAxon.example_conv_layer()
IO.puts("MLIR:")
IO.puts(mlir)

# Elixir to MLIR Examples
IO.puts("\n[Elixir to MLIR Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Function")
{_elixir, mlir} = ExMLIR.Examples.ElixirToMLIR.example_simple_function()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n2. Axon Model")
{_model, mlir} = ExMLIR.Examples.ElixirToMLIR.example_axon_model()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("Examples completed!")
IO.puts(String.duplicate("=", 70))

