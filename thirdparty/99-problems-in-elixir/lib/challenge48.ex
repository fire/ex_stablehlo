defmodule Challenge48 do
  @moduledoc """
  (**) Truth tables for logical expressions (3).
      Generalize problem P47 in such a way that the logical expression may contain any number of logical variables. Define table in a way that (table List Expr) prints the truth table for the expression Expr, which contains the logical variables enumerated in List.

      Example:
      * (table '(A B C) '((A and (B or C)) equ ((A and B) or (A and C)))).
      true true true true
      true true nil true
      true nil true true
      true nil nil true
      nil true true true
      nil true nil true
      nil nil true true
      nil nil nil true
  """

  def table_n(input_fn) do
    info = Function.info(input_fn)
    input_fn_arity = Keyword.get(info, :arity)

    if input_fn_arity == 0 do
      raise("Arity must not be zero")
    else
      args_list = build(input_fn_arity)

      for args <- args_list do
        args_joined = Enum.join(args, " ")
        func_result = "#{Kernel.apply(input_fn, args)}"
        args_joined <> " " <> func_result
      end
    end
  end

  defp build(1), do: [[true], [false]]

  defp build(k) do
    (k - 1) |> build() |> Enum.map(fn t -> [[false | t], [true | t]] end) |> Enum.concat()
  end
end
