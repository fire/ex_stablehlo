defmodule ExMLIR.Examples.Problems99.Runner do
  @moduledoc """
  Test runner for all 99 Problems in Elixir using StableHLO.

  Validates that MLIR→Nx conversions work correctly for all problems.
  """

  alias ExMLIR.Examples.Problems99.{
    ListOperations,
    Arithmetic,
    Logic,
    Trees,
    Graphs,
    Misc
  }

  @doc """
  Runs validation for all implemented problems.
  """
  def run_all do
    IO.puts("=" <> String.duplicate("=", 70))
    IO.puts("99 Problems in Elixir - StableHLO Validation")
    IO.puts("=" <> String.duplicate("=", 70))
    IO.puts()

    results = %{
      list_operations: run_list_operations(),
      arithmetic: run_arithmetic(),
      logic: run_logic(),
      trees: run_trees(),
      graphs: run_graphs(),
      misc: run_misc()
    }

    print_summary(results)
    results
  end

  defp run_list_operations do
    IO.puts("\n[List Operations - Problems 1-28]")
    IO.puts(String.duplicate("-", 70))

    problems = 1..28

    Enum.map(problems, fn n ->
      validate_problem(ListOperations, n)
    end)
  end

  defp run_arithmetic do
    IO.puts("\n[Arithmetic - Problems 31-41]")
    IO.puts(String.duplicate("-", 70))

    problems = 31..41

    Enum.map(problems, fn n ->
      validate_problem(Arithmetic, n)
    end)
  end

  defp run_logic do
    IO.puts("\n[Logic - Problems 46-50]")
    IO.puts(String.duplicate("-", 70))

    problems = 46..50

    Enum.map(problems, fn n ->
      validate_problem(Logic, n)
    end)
  end

  defp run_trees do
    IO.puts("\n[Trees - Problems 54-73]")
    IO.puts(String.duplicate("-", 70))

    problems = 54..73

    Enum.map(problems, fn n ->
      validate_problem(Trees, n)
    end)
  end

  defp run_graphs do
    IO.puts("\n[Graphs - Problems 80-91]")
    IO.puts(String.duplicate("-", 70))

    problems = 80..91

    Enum.map(problems, fn n ->
      validate_problem(Graphs, n)
    end)
  end

  defp run_misc do
    IO.puts("\n[Misc - Remaining Problems]")
    IO.puts(String.duplicate("-", 70))

    problems = [29, 30] ++ Enum.to_list(42..45) ++ Enum.to_list(51..53) ++ Enum.to_list(74..79) ++ Enum.to_list(92..99)

    Enum.map(problems, fn n ->
      validate_problem(Misc, n)
    end)
  end

  defp validate_problem(module, problem_num) do
    function_name = :"problem#{problem_num}_validate"

    case function_exported?(module, function_name, 0) do
      true ->
        try do
          results = apply(module, function_name, [])
          all_valid = Enum.all?(results, & &1.is_valid)

          status = if all_valid, do: "✓", else: "✗"
          IO.puts("#{status} Problem #{problem_num}")

          %{
            problem: problem_num,
            status: if(all_valid, do: :pass, else: :fail),
            results: results
          }
        rescue
          e ->
            IO.puts("✗ Problem #{problem_num} - Error: #{inspect(e)}")
            %{problem: problem_num, status: :error, error: e}
        end

      false ->
        # TODO: Problem not implemented
        IO.puts("○ Problem #{problem_num} - Not implemented")
        %{problem: problem_num, status: :not_implemented}
    end
  end

  defp print_summary(results) do
    IO.puts("\n" <> String.duplicate("=", 70))
    IO.puts("Summary")
    IO.puts(String.duplicate("=", 70))

    all_problems =
      results.list_operations ++
        results.arithmetic ++
        results.logic ++
        results.trees ++
        results.graphs ++
        results.misc

    total = length(all_problems)
    passed = Enum.count(all_problems, &(&1.status == :pass))
    failed = Enum.count(all_problems, &(&1.status == :fail))
    not_implemented = Enum.count(all_problems, &(&1.status == :not_implemented))
    errors = Enum.count(all_problems, &(&1.status == :error))

    IO.puts("Total Problems: #{total}")
    IO.puts("Passed: #{passed}")
    IO.puts("Failed: #{failed}")
    IO.puts("Not Implemented: #{not_implemented}")
    IO.puts("Errors: #{errors}")
    IO.puts(String.duplicate("=", 70))
  end
end

