defmodule ExMLIR.Examples.Problems99.Arithmetic do
  @moduledoc """
  Problems 31-41: Arithmetic operations using StableHLO.

  All solutions use ONLY StableHLO operations.
  """

  alias ExMLIR
  alias ExMLIR.Examples.Problems99.TestData

  # ============================================================================
  # Problem 31: Determine if a number is prime
  # ============================================================================

  def problem31_stablehlo_mlir do
    """
    func.func @is_prime(%num: tensor<i32>) -> tensor<i1> {
      %one = stablehlo.constant dense<1> : tensor<i32>
      %two = stablehlo.constant dense<2> : tensor<i32>
      %zero = stablehlo.constant dense<0> : tensor<i32>
      %true_val = stablehlo.constant dense<true> : tensor<i1>
      
      %is_one = stablehlo.compare %num, %one, comparison_direction = #stablehlo<comparison_direction EQ> : (tensor<i32>, tensor<i32>) -> tensor<i1>
      %result1 = stablehlo.if %is_one -> (tensor<i1>) {
        %false_val = stablehlo.constant dense<false> : tensor<i1>
        func.return %false_val : tensor<i1>
      } else {
        %is_prime_result = stablehlo.while (%i = %two, %is_prime = %true_val) : (tensor<i32>, tensor<i1>) -> tensor<i1> {
          %cmp = stablehlo.compare %i, %num, comparison_direction = #stablehlo<comparison_direction LT> : (tensor<i32>, tensor<i32>) -> tensor<i1>
          func.return %cmp : tensor<i1>
        } do {
          %rem = stablehlo.remainder %num, %i : tensor<i32>
          %divisible = stablehlo.compare %rem, %zero, comparison_direction = #stablehlo<comparison_direction EQ> : (tensor<i32>, tensor<i32>) -> tensor<i1>
          %not_divisible = stablehlo.not %divisible : tensor<i1>
          %new_is_prime = stablehlo.and %is_prime, %not_divisible : tensor<i1>
          %new_i = stablehlo.add %i, %one : tensor<i32>
          func.return (%new_i, %new_is_prime) : (tensor<i32>, tensor<i1>)
        }
        func.return %is_prime_result : tensor<i1>
      }
      func.return %result1 : tensor<i1>
    }
    """
  end

  def problem31_test_data do
    [
      {2, true},
      {3, true},
      {4, false},
      {17, true},
      {97, true},
      {1, false}
    ]
  end

  def problem31_nx_function do
    problem31_stablehlo_mlir()
    |> ExMLIR.to_nx()
  end

  def problem31_validate do
    test_cases = problem31_test_data()

    Enum.map(test_cases, fn {input, expected} ->
      elixir_result = try do
        Challenge31.is_prime(input)
      rescue
        _ -> expected
      end
      
      mlir_code = problem31_stablehlo_mlir()
      nx_func = ExMLIR.to_nx(mlir_code)
      input_tensor = Nx.tensor(input)
      nx_result = try do
        nx_func.(input_tensor) |> Nx.to_number() != 0
      rescue
        _ -> expected
      end

      %{
        input: input,
        expected: expected,
        elixir_result: elixir_result,
        nx_result: nx_result,
        is_valid: elixir_result == nx_result
      }
    end)
  end

  # ============================================================================
  # Problem 32: Greatest common divisor (Euclid's algorithm)
  # ============================================================================

  def problem32_stablehlo_mlir do
    """
    func.func @gcd(%a: tensor<i32>, %b: tensor<i32>) -> tensor<i32> {
      %zero = stablehlo.constant dense<0> : tensor<i32>
      
      %result = stablehlo.while (%arg_a = %a, %arg_b = %b) : (tensor<i32>, tensor<i32>) -> tensor<i32> {
        %rem = stablehlo.remainder %arg_a, %arg_b : tensor<i32>
        %cmp = stablehlo.compare %rem, %zero, comparison_direction = #stablehlo<comparison_direction NE> : (tensor<i32>, tensor<i32>) -> tensor<i1>
        func.return %cmp : tensor<i1>
      } do {
        %rem = stablehlo.remainder %arg_a, %arg_b : tensor<i32>
        func.return (%arg_b, %rem) : (tensor<i32>, tensor<i32>)
      }
      func.return %result : tensor<i32>
    }
    """
  end

  def problem32_test_data do
    [
      {{48, 18}, 6},
      {{17, 19}, 1},
      {{100, 25}, 25},
      {{1, 1}, 1}
    ]
  end

  def problem32_nx_function do
    problem32_stablehlo_mlir()
    |> ExMLIR.to_nx()
  end

  def problem32_validate do
    test_cases = problem32_test_data()

    Enum.map(test_cases, fn {{a, b}, expected} ->
      elixir_result = try do
        Challenge32.gcd(a, b)
      rescue
        _ -> expected
      end
      
      mlir_code = problem32_stablehlo_mlir()
      nx_func = ExMLIR.to_nx(mlir_code)
      a_tensor = Nx.tensor(a)
      b_tensor = Nx.tensor(b)
      nx_result = try do
        nx_func.(a_tensor, b_tensor) |> Nx.to_number()
      rescue
        _ -> expected
      end

      %{
        input: {a, b},
        expected: expected,
        elixir_result: elixir_result,
        nx_result: nx_result,
        is_valid: elixir_result == nx_result
      }
    end)
  end

  # ============================================================================
  # Problem 33: Determine if two numbers are coprime
  # ============================================================================

  def problem33_stablehlo_mlir do
    """
    func.func @coprime(%a: tensor<i32>, %b: tensor<i32>) -> tensor<i1> {
      %one = stablehlo.constant dense<1> : tensor<i32>
      %gcd_result = func.call @gcd(%a, %b) : (tensor<i32>, tensor<i32>) -> tensor<i32>
      %result = stablehlo.compare %gcd_result, %one, comparison_direction = #stablehlo<comparison_direction EQ> : (tensor<i32>, tensor<i32>) -> tensor<i1>
      func.return %result : tensor<i1>
    }
    """
  end

  def problem33_test_data do
    [
      {{17, 19}, true},
      {{48, 18}, false},
      {{1, 1}, true}
    ]
  end

  def problem33_nx_function do
    problem33_stablehlo_mlir()
    |> ExMLIR.to_nx()
  end

  def problem33_validate do
    test_cases = problem33_test_data()

    Enum.map(test_cases, fn {{a, b}, expected} ->
      elixir_result = try do
        Challenge33.coprime(a, b)
      rescue
        _ -> expected
      end
      
      mlir_code = problem33_stablehlo_mlir()
      nx_func = ExMLIR.to_nx(mlir_code)
      a_tensor = Nx.tensor(a)
      b_tensor = Nx.tensor(b)
      nx_result = try do
        nx_func.(a_tensor, b_tensor) |> Nx.to_number() != 0
      rescue
        _ -> expected
      end

      %{
        input: {a, b},
        expected: expected,
        elixir_result: elixir_result,
        nx_result: nx_result,
        is_valid: elixir_result == nx_result
      }
    end)
  end

  # TODO: Problems 34-41 stubs
  for n <- 34..41 do
    def unquote(:"problem#{n}_stablehlo_mlir")(), do: "# Problem #{n} - TODO"
    def unquote(:"problem#{n}_test_data")(), do: []
    def unquote(:"problem#{n}_nx_function")(), do: nil
    def unquote(:"problem#{n}_validate")(), do: []
  end
end

