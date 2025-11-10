# ExMLIR

A library for converting MLIR (StableHLO) to Elixir/Nx and Elixir code to MLIR. This library enables bidirectional translation between MLIR's StableHLO operations and Elixir's Nx numerical computing library.

## Features

- **MLIR to Elixir/Nx**: Convert MLIR (StableHLO) code to Elixir code strings and Nx computation functions
- **Elixir to MLIR**: Parse Elixir code and convert to MLIR (StableHLO) representation
- **MLIR Parser**: Parses MLIR text format (StableHLO) into an abstract syntax tree
- **Elixir Parser**: Parses Elixir code (using Sourceror) to extract Nx operations
- **StableHLO Support**: Only StableHLO is directly supported; all other MLIR dialects are emulated via StableHLO
- **AST Generation**: Uses [Sourceror](https://hex.pm/packages/sourceror) for proper Elixir AST construction

## Installation

Add `ex_mlir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_mlir, "~> 0.1.0"},
    {:nx, "~> 0.6"},
    {:sourceror, "~> 1.10"}
  ]
end
```

## Usage

### MLIR to Elixir/Nx

```elixir
mlir_code = """
func.func @add(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
  %0 = stablehlo.add %arg0, %arg1 : tensor<f32>
  func.return %0 : tensor<f32>
}
"""

# Convert to Elixir code string
elixir_code = ExMLIR.to_elixir(mlir_code)
# => "def add(inputs) do\n  Nx.add(Enum.at(inputs, 0), Enum.at(inputs, 1))\nend"

# Convert to Nx computation function
nx_func = ExMLIR.to_nx(mlir_code)
result = nx_func.(Nx.tensor(1.0), Nx.tensor(2.0))
# => #Nx.Tensor<f32[1.0]>
```

### Elixir to MLIR

```elixir
elixir_code = """
defn add(a, b) do
  Nx.add(a, b)
end
"""

# Convert to MLIR (StableHLO)
mlir_code = ExMLIR.from_elixir(elixir_code)
# => Returns MLIR code string with StableHLO operations
```

### Supported Operations

All operations use StableHLO. Other MLIR dialects are emulated via StableHLO.

#### StableHLO Operations

```elixir
# Arithmetic
"%0 = stablehlo.add %arg0, %arg1 : tensor<f32>"
"%0 = stablehlo.subtract %arg0, %arg1 : tensor<f32>"
"%0 = stablehlo.multiply %arg0, %arg1 : tensor<f32>"
"%0 = stablehlo.divide %arg0, %arg1 : tensor<f32>"

# Linear Algebra (for neural networks)
"%0 = stablehlo.dot_general %arg0, %arg1 : tensor<f32>"
"%0 = stablehlo.convolution %input, %filter : tensor<f32>"

# Control Flow
"%result = stablehlo.if %condition -> (tensor<f32>) { ... } else { ... }"
"%result = stablehlo.while (%arg = %init) : (tensor<f32>) -> (tensor<f32>) { ... }"
```

## Architecture

The library is organized into several key modules:

### Core Modules
- **`ExMLIR.Parser`**: Parses MLIR text format into an AST
- **`ExMLIR.Translator`**: Main translation engine that converts MLIR AST to target formats
- **`ExMLIR.ASTBuilder`**: Helper module using Sourceror for building Elixir ASTs
- **`ExMLIR.MLIRGenerator`**: Generates MLIR code from internal representation

### Dialect Modules
- **`ExMLIR.Dialects.*`**: Dialect-specific translators:
  - `Arith`: Arithmetic operations
  - `SCF`: Structured control flow
  - `Memref`: Memory operations
  - `Func`: Function definitions

### Emulation Framework
- **`ExMLIR.DialectStrategy`**: Strategy framework defining how to emulate each dialect
- **`ExMLIR.DialectEmulator`**: Runtime emulation engine for dialect operations

### Conversion Modules
- **`ExMLIR.ElixirParser`**: Parses Elixir code to extract Nx operations
- **`ExMLIR.AxonToMLIR`**: Converts Elixir operations to MLIR (StableHLO)

## Related Projects

- [MLIR](https://mlir.llvm.org/): The Multi-Level Intermediate Representation framework
- [Shardy](https://github.com/openxla/shardy): MLIR-based partitioning system (replacement for Google's SPMD)
- [Nx](https://hex.pm/packages/nx): Elixir's numerical computing library
- [Axon](https://hex.pm/packages/axon): Nx-powered neural networks for Elixir
- [Sourceror](https://hex.pm/packages/sourceror): Utilities for working with Elixir source code

## Dialect Emulation Strategies

**IMPORTANT**: This library ONLY directly supports StableHLO operations. All other MLIR dialects (including `arith`, `scf`, `memref`, `func`) must be emulated using StableHLO operations.

The library provides a comprehensive framework for emulating MLIR dialects through composition, masking, and transformation techniques. All dialects except StableHLO are emulated using strategic approaches:

### Emulation Approaches

1. **Direct Mapping**: Operations that have direct Nx/Axon equivalents
   - `arith`: Direct mapping to Nx arithmetic operations
   - `math`: Direct mapping to Nx mathematical functions

2. **Composition**: Operations built from lower-level operations
   - `tensor`: Composes `memref` operations with additional utilities
   - `linalg`: High-level linear algebra via Nx operations or composition
   - `vector`: SIMD operations mapped to Nx tensor operations

3. **Control Flow Emulation**: Using Elixir constructs
   - `scf`: Emulated via Elixir `if/else`, `Enum.reduce`, `Stream.iterate`
   - `affine`: Index computation with affine transformations

4. **Masking and Transformation**: Conditional execution and operation adaptation
   - Uses `Nx.select` for conditional operations
   - Transforms operations to match Nx/Axon semantics

### Supported Dialects

#### Directly Supported (ONLY StableHLO)
- ✅ `stablehlo`: StableHLO operations (ONLY directly supported MLIR dialect)

#### Emulated Dialects (using StableHLO)
All other MLIR dialects are emulated using StableHLO operations:

- 🔄 `arith`: Arithmetic operations → emulated via `stablehlo.add`, `stablehlo.subtract`, etc.
- 🔄 `scf`: Structured control flow → emulated via `stablehlo.if`, `stablehlo.while`
- 🔄 `memref`: Memory references → emulated via `stablehlo.gather`, `stablehlo.scatter`, `stablehlo.constant`
- 🔄 `func`: Function definitions → emulated via StableHLO function regions
- 🔄 `tensor`: Tensor operations → emulated via `stablehlo.slice`, `stablehlo.gather`, etc.
- 🔄 `linalg`: Linear algebra → emulated via `stablehlo.dot_general`, `stablehlo.convolution`
- 🔄 `affine`: Affine transformations → emulated via StableHLO with index computation
- 🔄 `vector`: Vector/SIMD operations → emulated via StableHLO tensor operations
- 🔄 `math`: Mathematical functions → emulated via `stablehlo.exp`, `stablehlo.log`, etc.
- 🔄 `complex`: Complex numbers → emulated via `stablehlo.complex`, `stablehlo.real`, `stablehlo.imag`
- 🔄 `index`: Index operations → emulated via StableHLO arithmetic
- 🔄 `shape`: Shape operations → emulated via StableHLO tensor shape operations

### Using Dialect Emulation

```elixir
# Check if a dialect can be emulated (requires stablehlo)
ExMLIR.DialectStrategy.can_emulate?(:linalg)
# => true (because stablehlo is available by default)

# Get emulation strategy for an operation
ExMLIR.DialectStrategy.get_operation_strategy(:linalg, :matmul)
# => {:stablehlo, :dot_general, "linalg.matmul -> stablehlo.dot_general"}

# Get emulation strategy for arith (emulated via stablehlo)
ExMLIR.DialectStrategy.get_operation_strategy(:arith, :addi)
# => {:stablehlo, :add, "arith.addi -> stablehlo.add"}

# Emulate a dialect operation
ExMLIR.DialectEmulator.emulate(:arith, :addi, [a, b], state, :stablehlo)
```

### Strategy Framework

The `ExMLIR.DialectStrategy` module provides:
- Operation mappings for each dialect
- Dependency tracking between dialects
- Emulation approach documentation
- Strategy lookup and validation

The `ExMLIR.DialectEmulator` module provides:
- Runtime emulation of dialect operations
- Masking utilities for conditional execution
- Operation composition for complex operations
- Transformation utilities for adapting operations

## Limitations

This is an early version of the library with the following limitations:

- Core dialects (arith, scf, memref, func) are fully implemented
- Additional dialects use emulation strategies (may have limitations)
- Simplified parsing (may not handle all MLIR syntax variations)
- Basic control flow translation (loops and conditionals need more work)
- Memory operations are mapped to Nx tensors (may not be optimal for all use cases)
- Some advanced MLIR features may require manual intervention

## Contributing

Contributions are welcome! Areas that need work:

- More comprehensive MLIR parsing
- Additional dialect support
- Better control flow translation
- Performance optimizations
- Test coverage

## License

Apache 2.0 - see LICENSE file for details.

