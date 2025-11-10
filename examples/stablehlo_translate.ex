defmodule ExMLIR.Examples.StableHLOTranslate do
  @moduledoc """
  Examples demonstrating the use of `ExMLIR.StableHLOTranslate` bindings.

  These examples show how to serialize StableHLO text to bytecode and
  deserialize bytecode back to text.
  """

  alias ExMLIR.StableHLOTranslate
  alias ExMLIR.Test.Fixtures.StableHLOText
  alias ExMLIR.Test.Fixtures.StableHLOByte

  @doc """
  Example: Serialize text to bytecode.
  """
  def example_serialize do
    IO.puts("=== Serialize Text to Bytecode ===\n")

    text = StableHLOText.simple_add()
    IO.puts("Input text:")
    IO.puts(text)
    IO.puts("\n")

    case StableHLOTranslate.serialize(text, target: "current") do
      {:ok, bytecode} ->
        IO.puts("Serialized to bytecode (#{byte_size(bytecode)} bytes)")
        IO.puts("First 100 bytes (hex):")
        IO.puts(bytecode |> binary_part(0, min(100, byte_size(bytecode))) |> Base.encode16(case: :lower))
        {:ok, bytecode}

      {:error, reason} ->
        IO.puts("Serialization failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Example: Deserialize bytecode to text.
  """
  def example_deserialize do
    IO.puts("=== Deserialize Bytecode to Text ===\n")

    # First serialize some text to get bytecode
    text = StableHLOText.simple_add()

    case StableHLOTranslate.serialize(text, target: "current") do
      {:ok, bytecode} ->
        IO.puts("Deserializing bytecode (#{byte_size(bytecode)} bytes)...\n")

        case StableHLOTranslate.deserialize(bytecode) do
          {:ok, deserialized_text} ->
            IO.puts("Deserialized text:")
            IO.puts(deserialized_text)
            {:ok, deserialized_text}

          {:error, reason} ->
            IO.puts("Deserialization failed: #{inspect(reason)}")
            {:error, reason}
        end

      {:error, reason} ->
        IO.puts("Failed to create bytecode for deserialization: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Example: Get version from bytecode.
  """
  def example_get_version do
    IO.puts("=== Get Version from Bytecode ===\n")

    text = StableHLOText.simple_add()

    case StableHLOTranslate.serialize(text, target: "current") do
      {:ok, bytecode} ->
        IO.puts("Getting version from bytecode...\n")

        case StableHLOTranslate.get_version(bytecode) do
          {:ok, version} ->
            IO.puts("StableHLO version: #{version}")
            {:ok, version}

          {:error, reason} ->
            IO.puts("Failed to get version: #{inspect(reason)}")
            {:error, reason}
        end

      {:error, reason} ->
        IO.puts("Failed to create bytecode: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Example: Round-trip conversion (text -> bytecode -> text).
  """
  def example_round_trip do
    IO.puts("=== Round-Trip Conversion ===\n")

    original_text = StableHLOText.simple_add()
    IO.puts("Original text:")
    IO.puts(original_text)
    IO.puts("\n")

    case StableHLOTranslate.serialize(original_text, target: "current") do
      {:ok, bytecode} ->
        IO.puts("Serialized to bytecode (#{byte_size(bytecode)} bytes)\n")

        case StableHLOTranslate.deserialize(bytecode) do
          {:ok, deserialized_text} ->
            IO.puts("Deserialized text:")
            IO.puts(deserialized_text)
            IO.puts("\n")

            if String.trim(original_text) == String.trim(deserialized_text) do
              IO.puts("✓ Round-trip successful: text matches!")
              {:ok, :round_trip_success}
            else
              IO.puts("⚠ Round-trip completed but text differs")
              IO.puts("Original length: #{String.length(original_text)}")
              IO.puts("Deserialized length: #{String.length(deserialized_text)}")
              {:ok, :round_trip_different}
            end

          {:error, reason} ->
            IO.puts("Deserialization failed: #{inspect(reason)}")
            {:error, reason}
        end

      {:error, reason} ->
        IO.puts("Serialization failed: #{inspect(reason)}")
        {:error, reason}
    end
  end

  @doc """
  Example: Check if stablehlo-translate is available.
  """
  def example_check_available do
    IO.puts("=== Check stablehlo-translate Availability ===\n")

    case StableHLOTranslate.check_available() do
      {:ok, path} ->
        IO.puts("✓ stablehlo-translate found at: #{path}")
        {:ok, path}

      {:error, :not_found} ->
        IO.puts("✗ stablehlo-translate not found in PATH")
        IO.puts("\nTo use these examples, you need to:")
        IO.puts("1. Build stablehlo-translate from the StableHLO repository")
        IO.puts("2. Add it to your PATH, or")
        IO.puts("3. Specify the path using the :executable option")
        {:error, :not_found}
    end
  end

  @doc """
  Run all examples.
  """
  def run_all do
    IO.puts("Running StableHLO Translate Examples\n")
    IO.puts(String.duplicate("=", 60))
    IO.puts("\n")

    # Check availability first
    case example_check_available() do
      {:ok, _path} ->
        example_serialize()
        IO.puts("\n")
        example_deserialize()
        IO.puts("\n")
        example_get_version()
        IO.puts("\n")
        example_round_trip()

      {:error, _} ->
        IO.puts("Skipping examples - stablehlo-translate not available")
    end
  end
end

