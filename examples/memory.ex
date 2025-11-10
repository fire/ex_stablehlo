defmodule ExMLIR.Examples.Memory do
  @moduledoc """
  Examples of converting memory operations between Elixir and MLIR.

  Demonstrates the `memref` dialect for memory references and operations.
  """

  alias ExMLIR

  @doc """
  Example: Tensor access operations.
  """
  def example_tensor_access do
    elixir_code = """
    defn access_tensor(tensor, idx) do
      Nx.tensor_slice(tensor, [idx])
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: Tensor update operations.
  """
  def example_tensor_update do
    elixir_code = """
    defn update_tensor(tensor, idx, value) do
      Nx.put_slice(tensor, [idx], value)
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  Example: List operations using memref.
  """
  def example_list_operations do
    elixir_code = """
    defn get_last_element(list) do
      len = Nx.axis_size(list, 0)
      idx = Nx.subtract(len, Nx.tensor(1))
      Nx.tensor_slice(list, [idx])
    end
    """

    mlir_code = ExMLIR.from_elixir(elixir_code)
    {elixir_code, mlir_code}
  end

  @doc """
  MLIR representation of memory access operations.
  """
  def mlir_memory_access do
    """
    func.func @access_element(%tensor: memref<10xi32>, %idx: i32) -> i32 {
      %val = memref.load %tensor[%idx] : memref<10xi32>
      return %val : i32
    }

    func.func @update_element(%tensor: memref<10xi32>, %idx: i32, %val: i32) {
      memref.store %val, %tensor[%idx] : memref<10xi32>
      return
    }
    """
  end

  @doc """
  MLIR representation of list operations.
  """
  def mlir_list_operations do
    """
    func.func @p01_my_last(%list: memref<?xi32>) -> i32 {
      %len = memref.dim %list, %c0 : index
      %len_i32 = arith.index_cast %len : index to i32
      %one = arith.constant 1 : i32
      %last_idx = arith.subi %len_i32, %one : i32
      %result = memref.load %list[%last_idx] : memref<?xi32>
      return %result : i32
    }

    func.func @p02_but_last(%list: memref<?xi32>) -> i32 {
      %len = memref.dim %list, %c0 : index
      %len_i32 = arith.index_cast %len : index to i32
      %two = arith.constant 2 : i32
      %target_idx = arith.subi %len_i32, %two : i32
      %result = memref.load %list[%target_idx] : memref<?xi32>
      return %result : i32
    }

    func.func @p03_find_k_item(%list: memref<?xi32>, %k: i32) -> i32 {
      %len = memref.dim %list, %c0 : index
      %len_i32 = arith.index_cast %len : index to i32
      %zero = arith.constant 0 : i32
      %one = arith.constant 1 : i32
      %cmp1 = arith.cmpi sgt, %k, %len_i32 : i32
      %cmp2 = arith.cmpi slt, %k, %zero : i32
      %cmp = arith.ori %cmp1, %cmp2 : i1
      %result = scf.if %cmp -> (i32) {
        %nil = arith.constant -1 : i32
        scf.yield %nil : i32
      } else {
        %idx = arith.subi %k, %one : i32
        %val = memref.load %list[%idx] : memref<?xi32>
        scf.yield %val : i32
      }
      return %result : i32
    }
    """
  end

  @doc """
  MLIR representation of tensor allocation.
  """
  def mlir_allocation do
    """
    func.func @allocate_tensor() -> memref<10x20xf32> {
      %tensor = memref.alloc() : memref<10x20xf32>
      return %tensor : memref<10x20xf32>
    }

    func.func @reverse_list(%input: memref<?xi32>, %output: memref<?xi32>) {
      %len = memref.dim %input, %c0 : index
      %len_i32 = arith.index_cast %len : index to i32
      %zero = arith.constant 0 : i32
      %one = arith.constant 1 : i32
      %len_minus_one = arith.subi %len_i32, %one : i32
      
      scf.for %i = %zero to %len_i32 step %one iter_args(%j = %len_minus_one) -> (i32) {
        %val = memref.load %input[%i] : memref<?xi32>
        memref.store %val, %output[%j] : memref<?xi32>
        %new_j = arith.subi %j, %one : i32
        scf.yield %new_j : i32
      }
      return
    }
    """
  end
end

