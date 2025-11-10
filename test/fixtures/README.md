# StableHLO Test Fixtures

This directory contains test fixtures for StableHLO in both text and byte formats.

## Text Format Fixtures

Text format fixtures are in `.mlir` format and can be found in:
- `ExMLIR.Test.Fixtures.StableHLOText` - Elixir module with text fixtures
- `thirdparty/stablehlo/stablehlo/testdata/*.mlir` - Official StableHLO test data
- `thirdparty/stablehlo/stablehlo/tests/interpret/*.mlir` - StableHLO interpreter tests

## Byte Format Fixtures

Byte format fixtures use MLIR bytecode format. StableHLO programs can be serialized to bytecode using:

```bash
stablehlo-translate --serialize --target=current input.mlir > output.bc
```

And deserialized using:

```bash
stablehlo-translate --deserialize input.bc > output.mlir
```

## Usage

```elixir
# Text fixtures
text_fixture = ExMLIR.Test.Fixtures.StableHLOText.simple_add()
{:ok, ast} = ExMLIR.Parser.parse(text_fixture)

# Byte fixtures (when available)
byte_fixture = ExMLIR.Test.Fixtures.StableHLOByte.simple_add_bytes()
{:ok, ast} = ExMLIR.Parser.parse_bytes(byte_fixture)
```

## Generating Bytecode Fixtures

To generate bytecode fixtures from text fixtures, you would need to:

1. Use `stablehlo-translate` tool to serialize text to bytecode
2. Store the bytecode files in a fixtures directory
3. Load them using `ExMLIR.Test.Fixtures.StableHLOByte.load_from_file/1`

## References

- [StableHLO Bytecode Documentation](https://github.com/openxla/stablehlo/blob/main/docs/bytecode.md)
- [MLIR Bytecode Format](https://mlir.llvm.org/docs/BytecodeFormat/)

