defmodule ExMLIR.Parser.StableHLOABNF do
  @moduledoc """
  StableHLO AST parser using ABNF grammar.

  This module uses the `ex_abnf` library to parse StableHLO MLIR code
  (both text and byte formats) into an abstract syntax tree (AST).

  The parser is based on the official StableHLO specification grammar,
  converted from EBNF to ABNF format.

  ## Usage

      iex> mlir_code = \"""
      ...> func.func @main(%arg0: tensor<f32>) -> tensor<f32> {
      ...>   %0 = "stablehlo.add"(%arg0, %arg0) : (tensor<f32>, tensor<f32>) -> tensor<f32>
      ...>   func.return %0 : tensor<f32>
      ...> }
      ...> \"""
      iex> ExMLIR.Parser.StableHLOABNF.parse(mlir_code)
      {:ok, ast}

      iex> ExMLIR.Parser.StableHLOABNF.parse_text(mlir_code)
      {:ok, ast}

      iex> ExMLIR.Parser.StableHLOABNF.parse_bytes(mlir_bytes)
      {:ok, ast}
  """

  alias ExABNF

  @grammar_file Path.join([__DIR__, "stablehlo.abnf"])

  @doc """
  Parses StableHLO MLIR code (text format) into an AST.

  Automatically detects whether input is text or bytes and parses accordingly.
  """
  def parse(input) when is_binary(input) do
    case detect_format(input) do
      :text -> parse_text(input)
      :bytes -> parse_bytes(input)
    end
  end

  @doc """
  Parses StableHLO MLIR code in text format into an AST.
  """
  def parse_text(text) when is_binary(text) do
    with {:ok, grammar} <- load_grammar(),
         {:ok, ast} <- ExABNF.parse(grammar, text, "Program") do
      {:ok, normalize_ast(ast)}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Parses StableHLO MLIR code in byte format into an AST.

  Note: Byte format parsing may require additional preprocessing
  depending on the serialization format used.
  """
  def parse_bytes(bytes) when is_binary(bytes) do
    # TODO: Convert bytes to text if needed, or handle binary format
    # TODO: For now, we'll assume bytes can be converted to text
    text = if String.valid?(bytes), do: bytes, else: decode_bytes(bytes)
    parse_text(text)
  end

  @doc """
  Loads the StableHLO ABNF grammar.
  """
  def load_grammar do
    case File.read(@grammar_file) do
      {:ok, grammar_text} ->
        case ExABNF.parse_grammar(grammar_text) do
          {:ok, grammar} -> {:ok, grammar}
          {:error, reason} -> {:error, {:grammar_parse_error, reason}}
        end

      {:error, reason} ->
        {:error, {:file_read_error, reason}}
    end
  end

  # ============================================================================
  # Private Functions
  # ============================================================================

  defp detect_format(input) do
    # TODO: Simple heuristic - if it's valid UTF-8 and contains MLIR keywords, it's text
    # This could be improved with proper MLIR bytecode format detection
    cond do
      String.valid?(input) and String.contains?(input, ["func.func", "stablehlo.", "tensor<"]) ->
        :text

      true ->
        :bytes
    end
  end

  defp decode_bytes(bytes) do
    # TODO: Attempt to decode as UTF-8, fallback to binary representation
    # This is a simplified approach - proper MLIR bytecode parsing would be needed
    case :unicode.characters_to_binary(bytes, :latin1) do
      {:error, _, _} -> bytes
      text -> text
    end
  end

  defp normalize_ast(ast) do
    # Convert ExABNF parse tree to our internal AST format
    case ast do
      # Program with functions
      {:rule, "Program", children} when is_list(children) ->
        functions = Enum.map(children, &normalize_func/1)
        {:program, functions}

      # Single function
      {:rule, "Func", children} when is_list(children) ->
        normalize_func(ast)

      # Other rules
      {:rule, rule_name, children} when is_list(children) ->
        normalize_rule(rule_name, children)

      # Terminal values
      {:terminal, value} ->
        value

      # Other structures
      other ->
        other
    end
  end

  defp normalize_func({:rule, "Func", children}) do
    # Extract function components
    func_id = extract_value(children, "FuncId")
    inputs = extract_value(children, "FuncInputs")
    outputs = extract_value(children, "FuncOutputs")
    body = extract_value(children, "FuncBody")

    {:func_def, func_id, normalize_inputs(inputs), normalize_outputs(outputs), normalize_body(body)}
  end

  defp normalize_func(other), do: other

  defp normalize_inputs({:rule, "FuncInputs", children}) do
    # Extract input list
    inputs = extract_list(children, "FuncInput")
    Enum.map(inputs, &normalize_input/1)
  end

  defp normalize_inputs(other), do: []  # TODO: Handle non-standard input formats

  defp normalize_input({:rule, "FuncInput", children}) do
    value_id = extract_value(children, "ValueId")
    value_type = extract_value(children, "ValueType")
    {value_id, normalize_type(value_type)}
  end

  defp normalize_outputs({:rule, "FuncOutputs", children}) do
    outputs = extract_list(children, "FuncOutput")
    Enum.map(outputs, &normalize_type/1)
  end

  defp normalize_outputs(_), do: []  # TODO: Handle missing outputs

  defp normalize_body({:rule, "FuncBody", children}) do
    ops = extract_list(children, "Op")
    Enum.map(ops, &normalize_op/1)
  end

  defp normalize_body(_), do: []  # TODO: Handle empty or invalid function bodies

  defp normalize_op({:rule, "Op", children}) do
    outputs = extract_optional(children, "OpOutputs")
    op_name = extract_value(children, "OpName")
    inputs = extract_value(children, "OpInputs")
    signature = extract_value(children, "OpSignature")

    {:op,
     normalize_op_name(op_name),
     normalize_outputs_list(outputs),
     normalize_op_inputs(inputs),
     normalize_signature(signature)}
  end

  defp normalize_op(other), do: other

  defp normalize_op_name({:rule, "OpName", children}) do
    mnemonic = extract_value(children, "OpMnemonic")
    case mnemonic do
      {:terminal, name} -> String.to_atom(name)
      other -> other
    end
  end

  defp normalize_op_inputs({:rule, "OpInputs", children}) do
    values = extract_optional(children, "OpInputValues")
    funcs = extract_optional(children, "OpInputFuncs")
    attrs = extract_optional(children, "OpInputAttrs")

    %{
      values: normalize_input_values(values),
      funcs: normalize_input_funcs(funcs),
      attrs: normalize_input_attrs(attrs)
    }
  end

  defp normalize_input_values({:rule, "OpInputValues", children}) do
    values = extract_list(children, "OpInputValue")
    Enum.map(values, &extract_value_id/1)
  end

  defp normalize_input_values(_), do: []  # TODO: Handle missing input values

  defp normalize_input_funcs({:rule, "OpInputFuncs", children}) do
    funcs = extract_list(children, "OpInputFunc")
    Enum.map(funcs, &normalize_input_func/1)
  end

  defp normalize_input_funcs(_), do: []  # TODO: Handle missing input functions

  defp normalize_input_func({:rule, "OpInputFunc", children}) do
    inputs = extract_value(children, "FuncInputs")
    body = extract_value(children, "FuncBody")
    {normalize_inputs(inputs), normalize_body(body)}
  end

  defp normalize_input_attrs({:rule, "OpInputAttrs", children}) do
    attrs = extract_list(children, "OpInputAttr")
    Enum.map(attrs, &normalize_attr/1)
  end

  defp normalize_input_attrs(_), do: []  # TODO: Handle missing input attributes

  defp normalize_attr({:rule, "OpInputAttr", children}) do
    name = extract_value(children, "OpInputAttrName")
    value = extract_value(children, "OpInputAttrValue")
    {extract_terminal(name), normalize_constant(value)}
  end

  defp normalize_outputs_list({:rule, "OpOutputs", children}) do
    outputs = extract_list(children, "OpOutput")
    Enum.map(outputs, &extract_value_id/1)
  end

  defp normalize_outputs_list(_), do: []  # TODO: Handle missing operation outputs

  defp normalize_signature({:rule, "OpSignature", children}) do
    # Extract input and output types
    input_types = extract_types_from_signature(children, "input")
    output_types = extract_types_from_signature(children, "output")
    {input_types, output_types}
  end

  defp extract_types_from_signature(children, direction) do
    # TODO: This is simplified - actual implementation would parse the signature more carefully
    types = extract_list(children, "ValueType")
    Enum.map(types, &normalize_type/1)
  end

  defp normalize_type({:rule, "TensorType", children}) do
    shape = extract_value(children, "Shape")
    element_type = extract_value(children, "TensorElementType")
    {:tensor, normalize_shape(shape), normalize_element_type(element_type)}
  end

  defp normalize_type({:rule, "IntegerType", children}) do
    type_str = extract_terminal_string(children)
    parse_integer_type(type_str)
  end

  defp normalize_type({:rule, "FloatType", children}) do
    type_str = extract_terminal_string(children)
    parse_float_type(type_str)
  end

  defp normalize_type(other) do
    # TODO: Handle unknown type format
    {:unknown_type, other}
  end

  defp normalize_shape({:rule, "Shape", children}) do
    dimensions = extract_list(children, "DimensionSize")
    Enum.map(dimensions, &normalize_dimension_size/1)
  end

  defp normalize_dimension_size({:rule, "DimensionSize", children}) do
    case extract_terminal_string(children) do
      "?" -> :dynamic
      size -> String.to_integer(size)
    end
  end

  defp normalize_element_type({:rule, "IntegerType", _}), do: :integer
  defp normalize_element_type({:rule, "FloatType", _}), do: :float
  defp normalize_element_type({:rule, "ComplexType", _}), do: :complex
  defp normalize_element_type({:rule, "BooleanType", _}), do: :boolean
  defp normalize_element_type(other) do
    # TODO: Handle unknown element type format
    {:unknown_element_type, other}
  end

  defp normalize_constant({:rule, "IntegerLiteral", children}) do
    value = extract_terminal_string(children)
    String.to_integer(value)
  end

  defp normalize_constant({:rule, "FloatLiteral", children}) do
    value = extract_terminal_string(children)
    String.to_float(value)
  end

  defp normalize_constant({:rule, "BooleanLiteral", children}) do
    value = extract_terminal_string(children)
    value == "true"
  end

  defp normalize_constant({:rule, "DenseElementsAttr", children}) do
    elements = extract_value(children, "DenseElements")
    type = extract_value(children, "ValueType")
    {:dense, normalize_dense_elements(elements), normalize_type(type)}
  end

  defp normalize_constant(other), do: {:constant, other}

  defp normalize_dense_elements({:rule, "DenseElements", children}) do
    elements = extract_list(children, "DenseElement")
    Enum.map(elements, &normalize_constant/1)
  end

  defp normalize_rule(rule_name, children) do
    {:rule, rule_name, Enum.map(children, &normalize_ast/1)}
  end

  # Helper functions for extracting values from parse trees

  defp extract_value(children, rule_name) when is_list(children) do
    case Enum.find(children, fn
           {:rule, ^rule_name, _} -> true
           _ -> false
         end) do
      {:rule, ^rule_name, sub_children} -> {:rule, rule_name, sub_children}
      nil -> nil
    end
  end

  defp extract_list(children, rule_name) when is_list(children) do
    Enum.filter_map(children, fn
      {:rule, ^rule_name, _} -> true
      _ -> false
    end, fn {:rule, ^rule_name, sub_children} -> {:rule, rule_name, sub_children} end)
  end

  defp extract_optional(children, rule_name) when is_list(children) do
    extract_value(children, rule_name)
  end

  defp extract_value_id({:rule, "ValueId", children}) do
    extract_terminal_string(children)
  end

  defp extract_terminal({:rule, rule_name, children}) do
    extract_terminal_string(children)
  end

  defp extract_terminal_string(children) when is_list(children) do
    children
    |> Enum.filter(&match?({:terminal, _}, &1))
    |> Enum.map(fn {:terminal, value} -> value end)
    |> Enum.join()
  end

  defp parse_integer_type("i" <> size), do: {:integer, String.to_integer(size)}
  defp parse_integer_type("si" <> size), do: {:signed_integer, String.to_integer(size)}
  defp parse_integer_type("ui" <> size), do: {:unsigned_integer, String.to_integer(size)}
  defp parse_integer_type(other) do
    # TODO: Handle unknown integer type format
    {:unknown_integer_type, other}
  end

  defp parse_float_type("f" <> size), do: {:float, String.to_integer(size)}
  defp parse_float_type("bf" <> size), do: {:bfloat, String.to_integer(size)}
  defp parse_float_type("f16"), do: {:float, 16}
  defp parse_float_type("bf16"), do: {:bfloat, 16}
  defp parse_float_type("f32"), do: {:float, 32}
  defp parse_float_type("f64"), do: {:float, 64}
  defp parse_float_type(other) do
    # TODO: Handle unknown float type format
    {:unknown_float_type, other}
  end
end

