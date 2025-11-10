defmodule ExMLIR.ASTBuilder do
  @moduledoc """
  Helper module for building Elixir ASTs using Sourceror.
  """

  alias Sourceror.Zipper, as: Z

  @doc """
  Builds a function call AST node.
  """
  def call(module, function, args) when is_atom(module) and is_atom(function) do
    module_ast = {:__aliases__, [line: 1], [module]}
    function_ast = {:., [line: 1], [module_ast, function]}
    {function_ast, [line: 1], normalize_args(args)}
  end

  def call(function, args) when is_atom(function) do
    {function, [line: 1], normalize_args(args)}
  end

  @doc """
  Builds a variable assignment AST node.
  """
  def assign(var_name, value) when is_atom(var_name) do
    {:=, [line: 1], [{var_name, [line: 1], nil}, value]}
  end

  @doc """
  Builds a function definition AST node.
  """
  def defun(name, args, body) when is_atom(name) do
    {:def, [line: 1], [
      {name, [line: 1], normalize_args(args)},
      [do: body]
    ]}
  end

  @doc """
  Builds a defn (Nx numerical definition) AST node.
  """
  def defn(name, args, body) when is_atom(name) do
    {:defn, [line: 1], [
      {name, [line: 1], normalize_args(args)},
      [do: body]
    ]}
  end

  @doc """
  Builds a variable reference AST node.
  """
  def var(name) when is_atom(name) do
    {name, [line: 1], nil}
  end

  @doc """
  Builds a literal value AST node.
  """
  def literal(value) when is_integer(value) or is_float(value) or is_atom(value) or is_binary(value) do
    value
  end

  @doc """
  Builds an access AST node (e.g., list[index]).
  """
  def access(container, index) do
    {{:., [line: 1], [{:__aliases__, [line: 1], []}, :access]}, [line: 1], [container, index]}
  end

  @doc """
  Builds a block AST (multiple statements).
  """
  def block(statements) when is_list(statements) do
    __MODULE__.block(statements, [])
  end

  def block([], acc), do: Enum.reverse(acc)
  def block([stmt | rest], acc) do
    block(rest, [stmt | acc])
  end

  @doc """
  Converts an AST to Elixir code string using Sourceror.
  """
  def to_string(ast) do
    Sourceror.to_string(ast)
  end

  @doc """
  Builds an Nx function call AST.
  """
  def nx_call(function, args) when is_atom(function) do
    module_ast = {:__aliases__, [line: 1], [:Nx]}
    function_ast = {:., [line: 1], [module_ast, function]}
    {function_ast, [line: 1], normalize_args(args)}
  end

  @doc """
  Builds an Enum.at call AST.
  """
  def enum_at(container, index) do
    module_ast = {:__aliases__, [line: 1], [:Enum]}
    function_ast = {:., [line: 1], [module_ast, :at]}
    {function_ast, [line: 1], [container, index]}
  end

  defp normalize_args(args) when is_list(args) do
    Enum.map(args, fn
      arg when is_atom(arg) -> {arg, [line: 1], nil}
      arg when is_integer(arg) or is_float(arg) or is_binary(arg) -> arg
      arg when is_tuple(arg) -> arg
      arg ->
        # TODO: Handle unknown argument format - returning as-is
        arg
    end)
  end

  defp normalize_args(arg), do: normalize_args([arg])
end

