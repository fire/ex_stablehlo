# ExMLIR Examples

Examples demonstrating MLIR (StableHLO) to Axon conversion and Elixir to MLIR conversion.

## Files

### Example Modules

- `mlir_to_axon.ex`: Convert MLIR (StableHLO) to Axon models
- `elixir_to_mlir.ex`: Convert Elixir code to MLIR (StableHLO)
- `axon_models.ex`: Axon model conversion examples
- `99_problems_stablehlo.ex`: StableHLO solutions for 99 Problems in Elixir

### Scripts

- `run_examples.exs`: Script to run all conversion examples

## Examples

### 1. Simple Arithmetic Operations

Convert basic arithmetic operations (add, subtract, multiply, divide) between Elixir and MLIR.

**Elixir:**
```elixir
defn add(a, b) do
  Nx.add(a, b)
end
```

**MLIR:**
```mlir
func.func @add(%arg0: i32, %arg1: i32) -> i32 {
  %0 = arith.addi %arg0, %arg1 : i32
  return %0 : i32
}
```

### 2. Conditional Operations

Convert conditional logic using `scf.if` dialect.

**Elixir:**
```elixir
defn max_value(a, b) do
  if Nx.greater(a, b) do
    a
  else
    b
  end
end
```

**MLIR:**
```mlir
func.func @max_value(%arg0: i32, %arg1: i32) -> i32 {
  %cmp = arith.cmpi sgt, %arg0, %arg1 : i32
  %result = scf.if %cmp -> (i32) {
    scf.yield %arg0 : i32
  } else {
    scf.yield %arg1 : i32
  }
  return %result : i32
}
```

### 3. Loop Operations

Convert loops using `scf.for` dialect.

**Elixir:**
```elixir
defn sum_range(n) do
  Enum.reduce(0..n, 0, fn i, acc ->
    Nx.add(acc, i)
  end)
end
```

**MLIR:**
```mlir
func.func @sum_range(%n: i32) -> i32 {
  %zero = arith.constant 0 : i32
  %one = arith.constant 1 : i32
  %n_plus_one = arith.addi %n, %one : i32
  %result = scf.for %i = %zero to %n_plus_one step %one iter_args(%acc = %zero) -> (i32) {
    %new_acc = arith.addi %acc, %i : i32
    scf.yield %new_acc : i32
  }
  return %result : i32
}
```

### 4. Memory Operations

Convert tensor operations using `memref` dialect.

**Elixir:**
```elixir
defn access_tensor(tensor, idx) do
  Nx.tensor_slice(tensor, [idx])
end
```

**MLIR:**
```mlir
func.func @access_tensor(%tensor: memref<?xi32>, %idx: i32) -> i32 {
  %val = memref.load %tensor[%idx] : memref<?xi32>
  return %val : i32
}
```

### 5. Function Composition

Convert function calls using `func` dialect.

**Elixir:**
```elixir
defn square(x) do
  Nx.multiply(x, x)
end

defn add_squares(a, b) do
  square_a = square(a)
  square_b = square(b)
  Nx.add(square_a, square_b)
end
```

**MLIR:**
```mlir
func.func @square(%x: i32) -> i32 {
  %result = arith.muli %x, %x : i32
  return %result : i32
}

func.func @add_squares(%a: i32, %b: i32) -> i32 {
  %square_a = func.call @square(%a) : (i32) -> i32
  %square_b = func.call @square(%b) : (i32) -> i32
  %result = arith.addi %square_a, %square_b : i32
  return %result : i32
}
```

## Running Examples

To run all examples:

```bash
elixir examples/run_examples.exs
```

Or in IEx:

```elixir
iex> Code.require_file("examples/99_problems_conversions.ex")
iex> ExMLIR.Examples.Problems99.example_addition()
```

## Dialect Coverage

The examples demonstrate:

- **arith**: All arithmetic operations (add, sub, mul, div, comparisons, bitwise)
- **scf**: Control flow (if/else, for loops, while loops)
- **memref**: Memory operations (alloc, load, store, dim)
- **func**: Function definitions and calls

## Notes

- Some Elixir constructs (like pattern matching, recursion) may require more complex MLIR representations
- List operations are represented using memref with dynamic dimensions
- The conversion preserves semantics but may use different control flow structures
- Round-trip conversion may produce slightly different but semantically equivalent code

