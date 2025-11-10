defmodule ExMLIR.Parser do
  @moduledoc """
  Parser for MLIR (StableHLO) text format.

  Parses MLIR code into an abstract syntax tree (AST) representation using
  ABNF grammar parser based on the official StableHLO specification.

  ## Usage

      # Parse text format
      ExMLIR.Parser.parse(mlir_code)

      # Parse byte format
      ExMLIR.Parser.parse_bytes(mlir_bytes)
  """

  alias ExMLIR.Parser.StableHLOABNF

  @doc """
  Parses MLIR code string into an AST using ABNF grammar parser.

  This provides accurate parsing based on the official StableHLO specification.
  """
  def parse(mlir_code) when is_binary(mlir_code) do
    StableHLOABNF.parse_text(mlir_code)
  end

  @doc """
  Parses MLIR code from bytes using ABNF grammar parser.
  """
  def parse_bytes(bytes) when is_binary(bytes) do
    StableHLOABNF.parse_bytes(bytes)
  end
end

