defmodule ExMLIR.DialectStrategy do
  @moduledoc """
  Strategy framework for emulating MLIR dialects.

  IMPORTANT: We ONLY support StableHLO operations directly.
  All other MLIR dialects (arith, scf, memref, func, tensor, linalg, etc.)
  must be emulated using StableHLO operations.

  This module provides a systematic approach to emulating MLIR dialects by
  mapping them to StableHLO operations through masking, transformations, and
  composition.
  """

  @doc """
  Returns a map of dialect emulation strategies.

  IMPORTANT: We ONLY support StableHLO operations directly.
  Everything else (arith, scf, memref, func, etc.) must be emulated using StableHLO.

  Each strategy includes:
  - Operations that need to be emulated
  - Mapping to StableHLO equivalents
  - Emulation approach (masking, composition, transformation)
  - Dependencies on other dialects
  """
  def strategies do
    %{
      # StableHLO (ONLY directly supported dialect)
      stablehlo: stablehlo_strategy(),

      # All other dialects must be emulated using StableHLO
      arith: arith_emulated_via_stablehlo(),
      scf: scf_emulated_via_stablehlo(),
      memref: memref_emulated_via_stablehlo(),
      func: func_emulated_via_stablehlo(),
      tensor: tensor_emulated_via_stablehlo(),
      linalg: linalg_emulated_via_stablehlo(),
      affine: affine_emulated_via_stablehlo(),
      vector: vector_emulated_via_stablehlo(),
      math: math_emulated_via_stablehlo(),
      complex: complex_emulated_via_stablehlo(),
      index: index_emulated_via_stablehlo(),
      shape: shape_emulated_via_stablehlo(),
    }
  end

  # ============================================================================
  # StableHLO Strategy (ONLY directly supported dialect)
  # ============================================================================

  defp stablehlo_strategy do
    %{
      approach: :direct_support,
      operations: %{
        # Arithmetic operations
        add: {:stablehlo, :add, "StableHLO addition"},
        subtract: {:stablehlo, :subtract, "StableHLO subtraction"},
        multiply: {:stablehlo, :multiply, "StableHLO multiplication"},
        divide: {:stablehlo, :divide, "StableHLO division"},
        remainder: {:stablehlo, :remainder, "StableHLO remainder"},
        max: {:stablehlo, :max, "StableHLO maximum"},
        min: {:stablehlo, :min, "StableHLO minimum"},
        
        # Comparison operations
        compare: {:stablehlo, :compare, "StableHLO comparison"},
        equal: {:stablehlo, :equal, "StableHLO equality"},
        not_equal: {:stablehlo, :not_equal, "StableHLO inequality"},
        greater: {:stablehlo, :greater, "StableHLO greater than"},
        greater_equal: {:stablehlo, :greater_equal, "StableHLO greater or equal"},
        less: {:stablehlo, :less, "StableHLO less than"},
        less_equal: {:stablehlo, :less_equal, "StableHLO less or equal"},
        
        # Logical operations
        and: {:stablehlo, :and, "StableHLO logical and"},
        or: {:stablehlo, :or, "StableHLO logical or"},
        xor: {:stablehlo, :xor, "StableHLO logical xor"},
        not: {:stablehlo, :not, "StableHLO logical not"},
        
        # Control flow
        if: {:stablehlo, :if, "StableHLO conditional"},
        while: {:stablehlo, :while, "StableHLO while loop"},
        case: {:stablehlo, :case, "StableHLO case statement"},
        
        # Tensor operations
        constant: {:stablehlo, :constant, "StableHLO constant"},
        iota: {:stablehlo, :iota, "StableHLO iota (range)"},
        reshape: {:stablehlo, :reshape, "StableHLO reshape"},
        transpose: {:stablehlo, :transpose, "StableHLO transpose"},
        slice: {:stablehlo, :slice, "StableHLO slice"},
        dynamic_slice: {:stablehlo, :dynamic_slice, "StableHLO dynamic slice"},
        dynamic_update_slice: {:stablehlo, :dynamic_update_slice, "StableHLO dynamic update slice"},
        concatenate: {:stablehlo, :concatenate, "StableHLO concatenate"},
        pad: {:stablehlo, :pad, "StableHLO pad"},
        gather: {:stablehlo, :gather, "StableHLO gather"},
        scatter: {:stablehlo, :scatter, "StableHLO scatter"},
        
        # Mathematical functions
        abs: {:stablehlo, :abs, "StableHLO absolute value"},
        exp: {:stablehlo, :exp, "StableHLO exponential"},
        expm1: {:stablehlo, :expm1, "StableHLO expm1"},
        log: {:stablehlo, :log, "StableHLO logarithm"},
        log1p: {:stablehlo, :log1p, "StableHLO log1p"},
        tanh: {:stablehlo, :tanh, "StableHLO hyperbolic tangent"},
        sin: {:stablehlo, :sin, "StableHLO sine"},
        cos: {:stablehlo, :cos, "StableHLO cosine"},
        sqrt: {:stablehlo, :sqrt, "StableHLO square root"},
        rsqrt: {:stablehlo, :rsqrt, "StableHLO reciprocal square root"},
        pow: {:stablehlo, :pow, "StableHLO power"},
        atan2: {:stablehlo, :atan2, "StableHLO arctangent2"},
        
        # Reduction operations
        reduce: {:stablehlo, :reduce, "StableHLO reduction"},
        reduce_window: {:stablehlo, :reduce_window, "StableHLO reduce window"},
        
        # Linear algebra
        dot_general: {:stablehlo, :dot_general, "StableHLO general dot product"},
        convolution: {:stablehlo, :convolution, "StableHLO convolution"},
        
        # Other operations
        select: {:stablehlo, :select, "StableHLO select (ternary)"},
        clamp: {:stablehlo, :clamp, "StableHLO clamp"},
        broadcast_in_dim: {:stablehlo, :broadcast_in_dim, "StableHLO broadcast"},
        real: {:stablehlo, :real, "StableHLO real part"},
        imag: {:stablehlo, :imag, "StableHLO imaginary part"},
        complex: {:stablehlo, :complex, "StableHLO complex number"},
      },
      dependencies: [],
      notes: "StableHLO is the ONLY directly supported MLIR dialect"
    }
  end

  # ============================================================================
  # Emulated Dialects (using StableHLO)
  # ============================================================================

  defp arith_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        addi: {:stablehlo, :add, "arith.addi -> stablehlo.add"},
        addf: {:stablehlo, :add, "arith.addf -> stablehlo.add"},
        subi: {:stablehlo, :subtract, "arith.subi -> stablehlo.subtract"},
        subf: {:stablehlo, :subtract, "arith.subf -> stablehlo.subtract"},
        muli: {:stablehlo, :multiply, "arith.muli -> stablehlo.multiply"},
        mulf: {:stablehlo, :multiply, "arith.mulf -> stablehlo.multiply"},
        divi: {:stablehlo, :divide, "arith.divi -> stablehlo.divide"},
        divf: {:stablehlo, :divide, "arith.divf -> stablehlo.divide"},
        cmpi: {:stablehlo, :compare, "arith.cmpi -> stablehlo.compare"},
        cmpf: {:stablehlo, :compare, "arith.cmpf -> stablehlo.compare"},
        andi: {:stablehlo, :and, "arith.andi -> stablehlo.and"},
        ori: {:stablehlo, :or, "arith.ori -> stablehlo.or"},
        xori: {:stablehlo, :xor, "arith.xori -> stablehlo.xor"},
      },
      dependencies: [:stablehlo],
      notes: "Arith dialect emulated using StableHLO operations"
    }
  end

  defp scf_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        for: {:stablehlo, :while, "scf.for -> stablehlo.while with counter"},
        if: {:stablehlo, :if, "scf.if -> stablehlo.if"},
        while: {:stablehlo, :while, "scf.while -> stablehlo.while"},
        yield: {:stablehlo, :constant, "scf.yield -> return value in stablehlo.while"},
        parallel: {:stablehlo, :while, "scf.parallel -> stablehlo.while with parallel semantics"},
      },
      dependencies: [:stablehlo],
      notes: "SCF dialect emulated using StableHLO control flow operations"
    }
  end

  defp memref_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        alloc: {:stablehlo, :constant, "memref.alloc -> stablehlo.constant with shape"},
        load: {:stablehlo, :gather, "memref.load -> stablehlo.gather"},
        store: {:stablehlo, :scatter, "memref.store -> stablehlo.scatter"},
        get_global: {:stablehlo, :constant, "memref.get_global -> stablehlo.constant"},
        dim: {:stablehlo, :reshape, "memref.dim -> extract from stablehlo tensor shape"},
        cast: {:stablehlo, :convert, "memref.cast -> stablehlo.convert"},
      },
      dependencies: [:stablehlo],
      notes: "Memref dialect emulated using StableHLO tensor operations"
    }
  end

  defp func_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        func: {:stablehlo, :func, "func.func -> stablehlo function region"},
        call: {:stablehlo, :call, "func.call -> stablehlo.call"},
        return: {:stablehlo, :return, "func.return -> stablehlo return"},
      },
      dependencies: [:stablehlo],
      notes: "Func dialect emulated using StableHLO function operations"
    }
  end

  defp tensor_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        extract: {:stablehlo, :gather, "tensor.extract -> stablehlo.gather"},
        insert: {:stablehlo, :scatter, "tensor.insert -> stablehlo.scatter"},
        extract_slice: {:stablehlo, :slice, "tensor.extract_slice -> stablehlo.slice"},
        insert_slice: {:stablehlo, :dynamic_update_slice, "tensor.insert_slice -> stablehlo.dynamic_update_slice"},
        dim: {:stablehlo, :reshape, "tensor.dim -> extract from stablehlo tensor shape"},
        rank: {:stablehlo, :reshape, "tensor.rank -> get rank from stablehlo tensor"},
        from_elements: {:stablehlo, :constant, "tensor.from_elements -> stablehlo.constant"},
        empty: {:stablehlo, :constant, "tensor.empty -> stablehlo.constant with zeros"},
        concat: {:stablehlo, :concatenate, "tensor.concat -> stablehlo.concatenate"},
        pad: {:stablehlo, :pad, "tensor.pad -> stablehlo.pad"},
      },
      dependencies: [:stablehlo],
      notes: "Tensor dialect emulated using StableHLO tensor operations"
    }
  end

  defp linalg_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        matmul: {:stablehlo, :dot_general, "linalg.matmul -> stablehlo.dot_general"},
        matvec: {:stablehlo, :dot_general, "linalg.matvec -> stablehlo.dot_general"},
        dot: {:stablehlo, :dot_general, "linalg.dot -> stablehlo.dot_general"},
        conv_2d: {:stablehlo, :convolution, "linalg.conv_2d -> stablehlo.convolution"},
        conv_3d: {:stablehlo, :convolution, "linalg.conv_3d -> stablehlo.convolution"},
        pool_2d: {:stablehlo, :reduce_window, "linalg.pool_2d -> stablehlo.reduce_window"},
        fill: {:stablehlo, :broadcast_in_dim, "linalg.fill -> stablehlo.broadcast_in_dim"},
        copy: {:stablehlo, :reshape, "linalg.copy -> stablehlo.reshape"},
        generic: {:stablehlo, :reduce, "linalg.generic -> stablehlo.reduce"},
      },
      dependencies: [:stablehlo],
      notes: "Linalg dialect emulated using StableHLO linear algebra operations"
    }
  end

  defp affine_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        affine_map: {:stablehlo, :dot_general, "affine.map -> stablehlo operations for index computation"},
        affine_apply: {:stablehlo, :add, "affine.apply -> stablehlo arithmetic operations"},
        affine_for: {:stablehlo, :while, "affine.for -> stablehlo.while"},
        affine_if: {:stablehlo, :if, "affine.if -> stablehlo.if"},
        affine_load: {:stablehlo, :gather, "affine.load -> stablehlo.gather with computed indices"},
        affine_store: {:stablehlo, :scatter, "affine.store -> stablehlo.scatter with computed indices"},
      },
      dependencies: [:stablehlo],
      notes: "Affine dialect emulated using StableHLO operations with index computation"
    }
  end

  defp vector_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        broadcast: {:stablehlo, :broadcast_in_dim, "vector.broadcast -> stablehlo.broadcast_in_dim"},
        extract: {:stablehlo, :gather, "vector.extract -> stablehlo.gather"},
        insert: {:stablehlo, :scatter, "vector.insert -> stablehlo.scatter"},
        fma: {:stablehlo, :multiply, "vector.fma -> stablehlo.multiply + stablehlo.add"},
        reduction: {:stablehlo, :reduce, "vector.reduction -> stablehlo.reduce"},
        transpose: {:stablehlo, :transpose, "vector.transpose -> stablehlo.transpose"},
        contract: {:stablehlo, :dot_general, "vector.contract -> stablehlo.dot_general"},
      },
      dependencies: [:stablehlo],
      notes: "Vector dialect emulated using StableHLO tensor operations"
    }
  end

  defp math_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        abs: {:stablehlo, :abs, "math.abs -> stablehlo.abs"},
        exp: {:stablehlo, :exp, "math.exp -> stablehlo.exp"},
        exp2: {:stablehlo, :pow, "math.exp2 -> stablehlo.pow"},
        log: {:stablehlo, :log, "math.log -> stablehlo.log"},
        log2: {:stablehlo, :log, "math.log2 -> stablehlo.log with base conversion"},
        log10: {:stablehlo, :log, "math.log10 -> stablehlo.log with base conversion"},
        powf: {:stablehlo, :pow, "math.powf -> stablehlo.pow"},
        rsqrt: {:stablehlo, :rsqrt, "math.rsqrt -> stablehlo.rsqrt"},
        sqrt: {:stablehlo, :sqrt, "math.sqrt -> stablehlo.sqrt"},
        sin: {:stablehlo, :sin, "math.sin -> stablehlo.sin"},
        cos: {:stablehlo, :cos, "math.cos -> stablehlo.cos"},
        tan: {:stablehlo, :divide, "math.tan -> stablehlo.sin / stablehlo.cos"},
        atan: {:stablehlo, :atan2, "math.atan -> stablehlo.atan2"},
        atan2: {:stablehlo, :atan2, "math.atan2 -> stablehlo.atan2"},
        ceil: {:stablehlo, :ceil, "math.ceil -> stablehlo.ceil (if available) or compose"},
        floor: {:stablehlo, :floor, "math.floor -> stablehlo.floor (if available) or compose"},
        round: {:stablehlo, :round, "math.round -> stablehlo.round (if available) or compose"},
      },
      dependencies: [:stablehlo],
      notes: "Math dialect emulated using StableHLO mathematical functions"
    }
  end

  defp complex_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        constant: {:stablehlo, :complex, "complex.constant -> stablehlo.complex"},
        add: {:stablehlo, :add, "complex.add -> stablehlo.add"},
        sub: {:stablehlo, :subtract, "complex.sub -> stablehlo.subtract"},
        mul: {:stablehlo, :multiply, "complex.mul -> stablehlo.multiply"},
        div: {:stablehlo, :divide, "complex.div -> stablehlo.divide"},
        abs: {:stablehlo, :abs, "complex.abs -> stablehlo.abs"},
        exp: {:stablehlo, :exp, "complex.exp -> stablehlo.exp"},
        log: {:stablehlo, :log, "complex.log -> stablehlo.log"},
        pow: {:stablehlo, :pow, "complex.pow -> stablehlo.pow"},
        sqrt: {:stablehlo, :sqrt, "complex.sqrt -> stablehlo.sqrt"},
        real: {:stablehlo, :real, "complex.real -> stablehlo.real"},
        imag: {:stablehlo, :imag, "complex.imag -> stablehlo.imag"},
      },
      dependencies: [:stablehlo],
      notes: "Complex dialect emulated using StableHLO complex operations"
    }
  end

  defp index_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        constant: {:stablehlo, :constant, "index.constant -> stablehlo.constant"},
        add: {:stablehlo, :add, "index.add -> stablehlo.add"},
        sub: {:stablehlo, :subtract, "index.sub -> stablehlo.subtract"},
        mul: {:stablehlo, :multiply, "index.mul -> stablehlo.multiply"},
        divs: {:stablehlo, :divide, "index.divs -> stablehlo.divide"},
        divu: {:stablehlo, :divide, "index.divu -> stablehlo.divide"},
        rems: {:stablehlo, :remainder, "index.rems -> stablehlo.remainder"},
        remu: {:stablehlo, :remainder, "index.remu -> stablehlo.remainder"},
        max: {:stablehlo, :max, "index.max -> stablehlo.max"},
        min: {:stablehlo, :min, "index.min -> stablehlo.min"},
        cast: {:stablehlo, :convert, "index.cast -> stablehlo.convert"},
      },
      dependencies: [:stablehlo],
      notes: "Index dialect emulated using StableHLO arithmetic operations"
    }
  end

  defp shape_emulated_via_stablehlo do
    %{
      approach: :emulate_via_stablehlo,
      operations: %{
        shape_of: {:stablehlo, :reshape, "shape.shape_of -> extract from stablehlo tensor"},
        num_elements: {:stablehlo, :reduce, "shape.num_elements -> compute from stablehlo tensor"},
        rank: {:stablehlo, :reshape, "shape.rank -> get rank from stablehlo tensor"},
        dim: {:stablehlo, :reshape, "shape.dim -> extract dimension from stablehlo tensor"},
        from_extents: {:stablehlo, :iota, "shape.from_extents -> stablehlo.iota"},
        split_at: {:stablehlo, :slice, "shape.split_at -> stablehlo.slice"},
        concat: {:stablehlo, :concatenate, "shape.concat -> stablehlo.concatenate"},
      },
      dependencies: [:stablehlo],
      notes: "Shape dialect emulated using StableHLO tensor shape operations"
    }
  end

  # ============================================================================
  # Emulation Helper Functions
  # ============================================================================

  @doc """
  Gets the emulation strategy for a specific dialect operation.
  """
  def get_operation_strategy(dialect, operation) do
    case Map.get(strategies(), dialect) do
      nil -> nil
      strategy -> Map.get(strategy.operations, operation)
    end
  end

  @doc """
  Checks if a dialect can be emulated given available dependencies.

  By default, only StableHLO is available (the only directly supported dialect).
  """
  def can_emulate?(dialect, available_dialects \\ [:stablehlo]) do
    case Map.get(strategies(), dialect) do
      nil -> false
      strategy ->
        Enum.all?(strategy.dependencies, &(&1 in available_dialects))
    end
  end

  @doc """
  Returns the emulation approach for a dialect.
  """
  def emulation_approach(dialect) do
    case Map.get(strategies(), dialect) do
      nil -> nil
      strategy -> strategy.approach
    end
  end
end

