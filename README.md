# ExMLIR

A library for converting MLIR (Multi-Level Intermediate Representation) to Elixir Nx and Axon code. This library provides support for minimal MLIR dialects including `arith`, `scf`, `memref`, and `func`, enabling translation of MLIR operations to Elixir's numerical computing ecosystem.

## Features

- **Bidirectional Conversion**: 
  - MLIR → Elixir Nx/Axon
  - Elixir Nx/Axon → MLIR
- **MLIR Parser**: Parses MLIR text format into an abstract syntax tree
- **Elixir Parser**: Parses Elixir code (using Sourceror) to extract Nx/Axon operations
- **Dialect Support**: 
  - Core dialects (fully implemented): `arith`, `scf`, `memref`, `func`
  - Additional dialects (emulated): `tensor`, `linalg`, `affine`, `vector`, `math`, `complex`, `index`, `shape`
- **Dialect Emulation Framework**: Systematic approach to emulating MLIR dialects through composition, masking, and transformation
- **AST Generation**: Uses [Sourceror](https://hex.pm/packages/sourceror) for proper Elixir AST construction
- **Multiple Output Formats**: 
  - Nx computation graphs
  - Axon models
  - Elixir code strings
  - MLIR code strings

## Installation

Add `ex_mlir` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_mlir, "~> 0.1.0"},
    {:nx, "~> 0.6"},
    {:axon, "~> 0.6"},
    {:sourceror, "~> 1.10"}
  ]
end
```

## Usage

### Basic Example

```elixir
mlir_code = """
func.func @main(%arg0: i32, %arg1: i32) -> i32 {
  %0 = arith.addi %arg0, %arg1 : i32
  return %0 : i32
}
"""

# Convert to Elixir code string
elixir_code = ExMLIR.to_elixir(mlir_code)
# => "def main(inputs) do\n  var_0 = Nx.add(Enum.at(inputs, 0), Enum.at(inputs, 1))\nend"

# Convert to Nx computation graph
nx_graph = ExMLIR.to_nx(mlir_code)

# Convert to Axon model
axon_model = ExMLIR.to_axon(mlir_code)
```

### Supported Operations

#### Arithmetic Operations

```elixir
# Addition
"%0 = arith.addi %arg0, %arg1 : i32"
"%0 = arith.addf %arg0, %arg1 : f32"

# Subtraction
"%0 = arith.subi %arg0, %arg1 : i32"
"%0 = arith.subf %arg0, %arg1 : f32"

# Multiplication
"%0 = arith.muli %arg0, %arg1 : i32"
"%0 = arith.mulf %arg0, %arg1 : f32"

# Division
"%0 = arith.divi %arg0, %arg1 : i32"
"%0 = arith.divf %arg0, %arg1 : f32"

# Comparisons
"%0 = arith.cmpi eq, %arg0, %arg1 : i32"
"%0 = arith.cmpf olt, %arg0, %arg1 : f32"

# Bitwise operations
"%0 = arith.andi %arg0, %arg1 : i32"
"%0 = arith.ori %arg0, %arg1 : i32"
"%0 = arith.xori %arg0, %arg1 : i32"
"%0 = arith.shli %arg0, %arg1 : i32"
"%0 = arith.shri %arg0, %arg1 : i32"
```

#### Memory Operations

```elixir
# Allocate memory
"%0 = memref.alloc() : memref<10x20xf32>"

# Load from memory
"%0 = memref.load %memref[%idx1, %idx2] : memref<10x20xf32>"

# Store to memory
"memref.store %value, %memref[%idx1, %idx2] : memref<10x20xf32>"

# Get dimension
"%0 = memref.dim %memref, %dim : index"
```

#### Control Flow

```elixir
# For loop
"scf.for %iv = %c0 to %c10 step %c1 iter_args(%arg = %init) -> (i32) { ... }"

# If conditional
"scf.if %condition -> (i32) { ... } else { ... }"

# While loop
"scf.while (%arg = %init) : (i32) -> (i32) { ... }"
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
- **`ExMLIR.ElixirParser`**: Parses Elixir code to extract Nx/Axon operations
- **`ExMLIR.NxToMLIR`**: Converts Nx operations to MLIR
- **`ExMLIR.AxonToMLIR`**: Converts Axon models to MLIR

## Related Projects

- [MLIR](https://mlir.llvm.org/): The Multi-Level Intermediate Representation framework
- [Shardy](https://github.com/openxla/shardy): MLIR-based partitioning system (replacement for Google's SPMD)
- [Nx](https://hex.pm/packages/nx): Elixir's numerical computing library
- [Axon](https://hex.pm/packages/axon): Nx-powered neural networks for Elixir
- [Sourceror](https://hex.pm/packages/sourceror): Utilities for working with Elixir source code

## Dialect Emulation Strategies

The library provides a comprehensive framework for emulating MLIR dialects through composition, masking, and transformation techniques. The core dialects (`arith`, `scf`, `memref`, `func`) are directly implemented, while additional dialects are emulated using strategic approaches:

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

#### Core Dialects (Fully Implemented)
- ✅ `arith`: Arithmetic operations
- ✅ `scf`: Structured control flow
- ✅ `memref`: Memory references
- ✅ `func`: Function definitions

#### Additional Dialects (Emulated)
- 🔄 `tensor`: Tensor operations (composes memref)
- 🔄 `linalg`: Linear algebra (high-level composition)
- 🔄 `affine`: Affine transformations (index computation)
- 🔄 `vector`: Vector/SIMD operations (tensor operations)
- 🔄 `math`: Mathematical functions (direct Nx mapping)
- 🔄 `complex`: Complex numbers (Nx complex or composition)
- 🔄 `index`: Index operations (integer arithmetic)
- 🔄 `shape`: Shape operations (tensor metadata)

### Using Dialect Emulation

```elixir
# Check if a dialect can be emulated
ExMLIR.DialectStrategy.can_emulate?(:linalg)
# => true

# Get emulation strategy for an operation
ExMLIR.DialectStrategy.get_operation_strategy(:linalg, :matmul)
# => {:nx, :dot, "Matrix multiplication via Nx.dot"}

# Emulate a dialect operation
ExMLIR.DialectEmulator.emulate(:linalg, :matmul, [a, b], state, :nx)
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

