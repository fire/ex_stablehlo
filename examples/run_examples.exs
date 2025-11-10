#!/usr/bin/env elixir

# Script to run MLIR to Elixir/Nx and Elixir to MLIR conversion examples

Mix.install([
  {:nx, "~> 0.6"},
  {:sourceror, "~> 1.10"}
])

# Load all example modules
Code.require_file("lib/ex_mlir.ex")
Code.require_file("examples/mlir_to_axon.ex")
Code.require_file("examples/elixir_to_mlir.ex")

# Note: mlir_to_axon.ex was renamed to MLIRToNx module

IO.puts("=" <> String.duplicate("=", 70))
IO.puts("ExMLIR - MLIR to Elixir/Nx and Elixir to MLIR Examples")
IO.puts("=" <> String.duplicate("=", 70))
IO.puts()

# MLIR to Elixir/Nx Examples
IO.puts("\n[MLIR to Elixir/Nx Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Addition")
{mlir, elixir, _nx_func} = ExMLIR.Examples.MLIRToNx.example_simple_add()
IO.puts("MLIR:")
IO.puts(mlir)
IO.puts("\nElixir:")
IO.puts(elixir)

IO.puts("\n2. Dense Operation")
{mlir, elixir, _nx_func} = ExMLIR.Examples.MLIRToNx.example_dense_operation()
IO.puts("MLIR:")
IO.puts(mlir)
IO.puts("\nElixir:")
IO.puts(elixir)

IO.puts("\n3. Convolution Operation")
{mlir, elixir, _nx_func} = ExMLIR.Examples.MLIRToNx.example_conv_operation()
IO.puts("MLIR:")
IO.puts(mlir)
IO.puts("\nElixir:")
IO.puts(elixir)

# Elixir to MLIR Examples
IO.puts("\n[Elixir to MLIR Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Function")
{_elixir, mlir} = ExMLIR.Examples.ElixirToMLIR.example_simple_function()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n2. Nx Function")
{_elixir, mlir} = ExMLIR.Examples.ElixirToMLIR.example_nx_function()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n3. Complex Computation")
{_elixir, mlir} = ExMLIR.Examples.ElixirToMLIR.example_complex_computation()
IO.puts("MLIR:")
IO.puts(mlir)

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("Examples completed!")
IO.puts(String.duplicate("=", 70))

