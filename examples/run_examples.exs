#!/usr/bin/env elixir

# Script to run all 99 Problems conversion examples

Mix.install([
  {:nx, "~> 0.6"},
  {:axon, "~> 0.6"},
  {:sourceror, "~> 1.10"}
])

# Load all example modules
Code.require_file("lib/ex_mlir.ex")
Code.require_file("examples/arithmetic.ex")
Code.require_file("examples/control_flow.ex")
Code.require_file("examples/memory.ex")
Code.require_file("examples/functions.ex")
Code.require_file("examples/round_trip.ex")
Code.require_file("examples/axon_models.ex")

IO.puts("=" <> String.duplicate("=", 70))
IO.puts("99 Problems in Elixir - MLIR Conversion Examples")
IO.puts("=" <> String.duplicate("=", 70))
IO.puts()

# Arithmetic Examples
IO.puts("\n[Arithmetic Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Addition")
{_, mlir, _} = ExMLIR.Examples.Arithmetic.example_addition()
IO.puts(mlir)

IO.puts("\n2. Multiple Operations")
{_, mlir} = ExMLIR.Examples.Arithmetic.example_multiple_ops()
IO.puts(mlir)

IO.puts("\n3. Quadratic Formula")
{_, mlir, _} = ExMLIR.Examples.Arithmetic.example_quadratic()
IO.puts(mlir)

# Control Flow Examples
IO.puts("\n[Control Flow Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Conditional Operations")
{_, mlir} = ExMLIR.Examples.ControlFlow.example_conditional()
IO.puts(mlir)

IO.puts("\n2. Loop Operations")
{_, mlir} = ExMLIR.Examples.ControlFlow.example_loop()
IO.puts(mlir)

# Memory Examples
IO.puts("\n[Memory Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Tensor Access")
{_, mlir} = ExMLIR.Examples.Memory.example_tensor_access()
IO.puts(mlir)

IO.puts("\n2. List Operations")
IO.puts(ExMLIR.Examples.Memory.mlir_list_operations())

# Function Examples
IO.puts("\n[Function Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Function Composition")
{_, mlir} = ExMLIR.Examples.Functions.example_function_composition()
IO.puts(mlir)

IO.puts("\n2. Helper Functions")
IO.puts(ExMLIR.Examples.Functions.mlir_helper_functions())

# Round-trip Examples
IO.puts("\n[Round-trip Examples]")
IO.puts(String.duplicate("-", 70))
IO.puts("\n1. Simple Round-trip")
{_, mlir, _} = ExMLIR.Examples.RoundTrip.example_round_trip()
IO.puts(mlir)

IO.puts("\n2. MLIR to Nx")
{mlir, nx} = ExMLIR.Examples.RoundTrip.example_mlir_to_nx()
IO.puts("MLIR:")
IO.puts(mlir)
IO.puts("\nNx:")
IO.puts(nx)

IO.puts("\n" <> String.duplicate("=", 70))
IO.puts("Examples completed!")
IO.puts(String.duplicate("=", 70))

