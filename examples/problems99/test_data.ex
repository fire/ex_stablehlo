defmodule ExMLIR.Examples.Problems99.TestData do
  @moduledoc """
  Test data generators and validation functions for 99 Problems in Elixir.

  Provides test data generators for each problem type and validation functions
  to compare Elixir results with MLIR→Axon conversion results.
  """

  @doc """
  Generates test data for list-based problems.
  """
  def generate_list_test_data do
    [
      {[], :empty_list},
      {[1], :single_element},
      {[1, 2, 3, 4, 5], :small_list},
      {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10], :medium_list},
      {Enum.to_list(1..100), :large_list},
      {[1, 1, 2, 2, 3, 3], :duplicates},
      {[1, 2, 1, 2, 1, 2], :alternating},
      {[5, 4, 3, 2, 1], :reverse_order}
    ]
  end

  @doc """
  Generates test data for arithmetic problems.
  """
  def generate_arithmetic_test_data do
    [
      {2, :small_prime},
      {3, :small_prime},
      {17, :medium_prime},
      {97, :large_prime},
      {4, :composite},
      {15, :composite},
      {100, :composite},
      {1, :edge_case},
      {0, :edge_case}
    ]
  end

  @doc """
  Generates test data for pair-based problems (GCD, etc.).
  """
  def generate_pair_test_data do
    [
      {{48, 18}, :standard},
      {{17, 19}, :coprime},
      {{100, 25}, :divisible},
      {{1, 1}, :edge_case},
      {{0, 5}, :edge_case}
    ]
  end

  @doc """
  Generates test data for logic problems.
  """
  def generate_logic_test_data do
    [
      {{true, true}, :both_true},
      {{true, false}, :first_true},
      {{false, true}, :second_true},
      {{false, false}, :both_false}
    ]
  end

  @doc """
  Converts Elixir list to Nx tensor for testing.
  """
  def list_to_tensor(list) when is_list(list) do
    if Enum.empty?(list) do
      Nx.tensor([])
    else
      Nx.tensor(list)
    end
  end

  @doc """
  Converts Nx tensor to Elixir list for comparison.
  """
  def tensor_to_list(tensor) do
    tensor
    |> Nx.to_flat_list()
  end

  @doc """
  Validates that two results are approximately equal (for floating point).
  """
  def validate_result(actual, expected, opts \\ []) do
    tolerance = Keyword.get(opts, :tolerance, 1.0e-6)

    cond do
      is_number(actual) and is_number(expected) ->
        abs(actual - expected) < tolerance

      is_list(actual) and is_list(expected) ->
        validate_list_result(actual, expected, tolerance)

      is_map(actual) and is_map(expected) ->
        # For Nx tensors
        if Nx.type(actual) == Nx.type(expected) do
          diff = Nx.subtract(actual, expected) |> Nx.abs()
          Nx.all(Nx.less(diff, tolerance))
        else
          false
        end

      true ->
        actual == expected
    end
  end

  defp validate_list_result(actual, expected, tolerance) do
    if length(actual) == length(expected) do
      Enum.zip(actual, expected)
      |> Enum.all?(fn {a, e} ->
        if is_number(a) and is_number(e) do
          abs(a - e) < tolerance
        else
          a == e
        end
      end)
    else
      false
    end
  end

  @doc """
  Runs test data through both Elixir function and MLIR→Nx conversion.
  """
  def run_comparison_test(elixir_fun, mlir_code, test_data, opts \\ []) do
    # Run through Elixir function
    elixir_result = apply(elixir_fun, test_data)

    # Convert MLIR to Nx function
    nx_func = ExMLIR.to_nx(mlir_code)

    # Run through Nx function
    nx_result = run_nx_function(nx_func, test_data)

    # Compare results
    is_valid = validate_result(nx_result, elixir_result, opts)

    %{
      test_data: test_data,
      elixir_result: elixir_result,
      nx_result: nx_result,
      is_valid: is_valid
    }
  end

  defp run_nx_function(func, inputs) when is_list(inputs) do
    # Convert inputs to tensors
    input_tensors = Enum.map(inputs, &list_to_tensor/1)

    # Run function
    apply(func, input_tensors)
  end

  defp run_nx_function(func, input) do
    input_tensor = if is_list(input), do: list_to_tensor(input), else: Nx.tensor(input)
    func.(input_tensor)
  end

  @doc """
  Generates test cases for a specific problem number.
  """
  def generate_problem_test_cases(problem_num) do
    case problem_num do
      n when n in 1..28 ->
        generate_list_test_data()

      n when n in 31..41 ->
        generate_arithmetic_test_data()

      n when n in 46..50 ->
        generate_logic_test_data()

      _ ->
        []
    end
  end
end

