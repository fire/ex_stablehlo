defmodule ExMLIR.StableHLOTranslate do
  @moduledoc """
  Elixir bindings for the `stablehlo-translate` command-line tool.

  Provides functions to serialize StableHLO text to bytecode and deserialize
  bytecode back to text format.

  ## Usage

      # Serialize text to bytecode
      {:ok, bytecode} = ExMLIR.StableHLOTranslate.serialize(text_mlir, target: "current")

      # Deserialize bytecode to text
      {:ok, text} = ExMLIR.StableHLOTranslate.deserialize(bytecode)

      # Get version from bytecode
      {:ok, version} = ExMLIR.StableHLOTranslate.get_version(bytecode)
  """

  @doc """
  Serializes StableHLO text format to bytecode.

  ## Options

    * `:target` - Target StableHLO version (e.g., "0.9.0", "current"). Defaults to "current".
    * `:allow_other_dialects` - Allow mixed dialects in serialization. Defaults to `false`.
    * `:strip_debuginfo` - Strip debug info from operations. Defaults to `false`.
    * `:executable` - Path to stablehlo-translate executable. Defaults to searching PATH.

  ## Examples

      iex> text = "module { func.func @main() -> tensor<f32> { ... } }"
      iex> {:ok, bytecode} = ExMLIR.StableHLOTranslate.serialize(text)
      {:ok, <<...>>}

      iex> {:ok, bytecode} = ExMLIR.StableHLOTranslate.serialize(text, target: "0.9.0")
      {:ok, <<...>>}
  """
  def serialize(text, opts \\ []) when is_binary(text) do
    target = Keyword.get(opts, :target, "current")
    allow_other_dialects = Keyword.get(opts, :allow_other_dialects, false)
    strip_debuginfo = Keyword.get(opts, :strip_debuginfo, false)
    executable = Keyword.get(opts, :executable, find_executable())

    args = build_serialize_args(target, allow_other_dialects, strip_debuginfo)

    case System.cmd(executable, args, input: text, stderr_to_stdout: true) do
      {output, 0} ->
        {:ok, output}

      {error_output, exit_code} ->
        {:error, {:serialization_failed, exit_code, error_output}}
    end
  end

  @doc """
  Deserializes StableHLO bytecode to text format.

  ## Options

    * `:print_stablehlo_version` - Print StableHLO version when deserializing. Defaults to `false`.
    * `:executable` - Path to stablehlo-translate executable. Defaults to searching PATH.

  ## Examples

      iex> {:ok, text} = ExMLIR.StableHLOTranslate.deserialize(bytecode)
      {:ok, "module { ... }"}

      iex> {:ok, text} = ExMLIR.StableHLOTranslate.deserialize(bytecode, print_stablehlo_version: true)
      {:ok, "// Reading portable artifact with StableHLO version: 0.9.0\\nmodule { ... }"}
  """
  def deserialize(bytecode, opts \\ []) when is_binary(bytecode) do
    print_version = Keyword.get(opts, :print_stablehlo_version, false)
    executable = Keyword.get(opts, :executable, find_executable())

    args = build_deserialize_args(print_version)

    case System.cmd(executable, args, input: bytecode, stderr_to_stdout: true) do
      {output, 0} ->
        {:ok, output}

      {error_output, exit_code} ->
        {:error, {:deserialization_failed, exit_code, error_output}}
    end
  end

  @doc """
  Gets the StableHLO version from a bytecode artifact.

  This reads the version information embedded in the bytecode header.

  ## Options

    * `:executable` - Path to stablehlo-translate executable. Defaults to searching PATH.

  ## Examples

      iex> {:ok, version} = ExMLIR.StableHLOTranslate.get_version(bytecode)
      {:ok, "0.9.0"}

      iex> ExMLIR.StableHLOTranslate.get_version(invalid_bytecode)
      {:error, :invalid_bytecode}
  """
  def get_version(bytecode, opts \\ []) when is_binary(bytecode) do
    executable = Keyword.get(opts, :executable, find_executable())

    args = ["--deserialize", "--print-stablehlo-version"]

    case System.cmd(executable, args, input: bytecode, stderr_to_stdout: true) do
      {output, 0} ->
        # Parse version from output like:
        # "// Reading portable artifact with StableHLO version: 0.9.0\nmodule { ... }"
        case Regex.run(~r/StableHLO version:\s+([0-9]+\.[0-9]+\.[0-9]+)/, output) do
          [_, version] -> {:ok, version}
          _ -> {:error, :version_not_found}
        end

      {_error_output, _exit_code} ->
        {:error, :invalid_bytecode}
    end
  end

  @doc """
  Checks if stablehlo-translate is available.

  Returns `{:ok, path}` if found, `{:error, :not_found}` otherwise.

  ## Options

    * `:executable` - Path to stablehlo-translate executable. Defaults to searching PATH.

  ## Examples

      iex> ExMLIR.StableHLOTranslate.check_available()
      {:ok, "/usr/local/bin/stablehlo-translate"}

      iex> ExMLIR.StableHLOTranslate.check_available(executable: "/custom/path/stablehlo-translate")
      {:ok, "/custom/path/stablehlo-translate"}
  """
  def check_available(opts \\ []) do
    executable = Keyword.get(opts, :executable, find_executable())

    # If an absolute path is provided, check if it exists
    if String.starts_with?(executable, "/") do
      if File.exists?(executable) do
        {:ok, executable}
      else
        {:error, :not_found}
      end
    else
      # Search in PATH
      case System.find_executable(executable) do
        nil -> {:error, :not_found}
        path -> {:ok, path}
      end
    end
  end

  # Private helper functions

  defp find_executable do
    "stablehlo-translate"
  end

  defp build_serialize_args(target, allow_other_dialects, strip_debuginfo) do
    args = ["--serialize"]

    args =
      if target != "" do
        ["--target=#{target}" | args]
      else
        args
      end

    args =
      if allow_other_dialects do
        ["--allow-other-dialects" | args]
      else
        args
      end

    args =
      if strip_debuginfo do
        ["--strip-debuginfo" | args]
      else
        args
      end

    Enum.reverse(args)
  end

  defp build_deserialize_args(print_version) do
    args = ["--deserialize"]

    args =
      if print_version do
        ["--print-stablehlo-version" | args]
      else
        args
      end

    Enum.reverse(args)
  end
end

