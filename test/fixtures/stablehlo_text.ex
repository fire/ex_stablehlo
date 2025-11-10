defmodule ExMLIR.Test.Fixtures.StableHLOText do
  @moduledoc """
  StableHLO test fixtures in text format (.mlir).

  These fixtures are sourced from the official StableHLO testdata directory.
  """

  @doc """
  Simple addition operation.
  Source: thirdparty/stablehlo/stablehlo/tests/interpret/add.mlir
  """
  def simple_add do
    """
    module {
      func.func @main(%arg0: tensor<f32>, %arg1: tensor<f32>) -> tensor<f32> {
        %0 = stablehlo.add %arg0, %arg1 : tensor<f32>
        func.return %0 : tensor<f32>
      }
    }
    """
  end

  @doc """
  Reverse operation on a tensor.
  """
  def reverse_tensor do
    """
    module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
      func.func public @main() -> (tensor<4x5xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
        %0 = call @inputs() : () -> tensor<4x5xi32>
        %1 = call @expected() : () -> tensor<4x5xi32>
        %2 = stablehlo.reverse %0, dims = [0] : tensor<4x5xi32>
        stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<4x5xi32>, tensor<4x5xi32>) -> ()
        return %2 : tensor<4x5xi32>
      }
      func.func private @inputs() -> (tensor<4x5xi32> {mhlo.layout_mode = "default"}) {
        %c = stablehlo.constant dense<[[4, -3, 2, 1, 3], [-2, 1, -2, 5, 1], [-2, -1, -1, 4, -3], [0, 3, -1, -4, 2]]> : tensor<4x5xi32>
        return %c : tensor<4x5xi32>
      }
      func.func private @expected() -> (tensor<4x5xi32> {mhlo.layout_mode = "default"}) {
        %c = stablehlo.constant dense<[[0, 3, -1, -4, 2], [-2, -1, -1, 4, -3], [-2, 1, -2, 5, 1], [4, -3, 2, 1, 3]]> : tensor<4x5xi32>
        return %c : tensor<4x5xi32>
      }
    }
    """
  end

  @doc """
  Dynamic slice operation.
  """
  def dynamic_slice do
    """
    module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
      func.func public @main() -> (tensor<1xi32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
        %0:2 = call @inputs() : () -> (tensor<3xi32>, tensor<1xi64>)
        %1 = call @expected() : () -> tensor<1xi32>
        %2 = stablehlo.slice %0#1 [0:1] : (tensor<1xi64>) -> tensor<1xi64>
        %3 = stablehlo.reshape %2 : (tensor<1xi64>) -> tensor<i64>
        %c = stablehlo.constant dense<0> : tensor<i64>
        %4 = stablehlo.compare  LT, %3, %c,  SIGNED : (tensor<i64>, tensor<i64>) -> tensor<i1>
        %c_0 = stablehlo.constant dense<3> : tensor<i64>
        %5 = stablehlo.add %3, %c_0 : tensor<i64>
        %6 = stablehlo.select %4, %5, %3 : tensor<i1>, tensor<i64>
        %7 = stablehlo.dynamic_slice %0#0, %6, sizes = [1] : (tensor<3xi32>, tensor<i64>) -> tensor<1xi32>
        stablehlo.custom_call @check.expect_eq(%7, %1) {has_side_effect = true} : (tensor<1xi32>, tensor<1xi32>) -> ()
        return %7 : tensor<1xi32>
      }
      func.func private @inputs() -> (tensor<3xi32> {mhlo.layout_mode = "default"}, tensor<1xi64> {mhlo.layout_mode = "default"}) {
        %c = stablehlo.constant dense<[3, -1, 3]> : tensor<3xi32>
        %c_0 = stablehlo.constant dense<1> : tensor<1xi64>
        return %c, %c_0 : tensor<3xi32>, tensor<1xi64>
      }
      func.func private @expected() -> (tensor<1xi32> {mhlo.layout_mode = "default"}) {
        %c = stablehlo.constant dense<-1> : tensor<1xi32>
        return %c : tensor<1xi32>
      }
    }
    """
  end

  @doc """
  Constant operation with dense elements.
  Source: thirdparty/stablehlo/stablehlo/tests/interpret/constant.mlir
  """
  def constant_dense do
    """
    module {
      func.func @main() -> tensor<2x3xf32> {
        %0 = stablehlo.constant dense<[[1.0, 2.0, 3.0], [4.0, 5.0, 6.0]]> : tensor<2x3xf32>
        func.return %0 : tensor<2x3xf32>
      }
    }
    """
  end

  @doc """
  Dot general operation (matrix multiplication).
  """
  def dot_general do
    """
    module {
      func.func @main(%arg0: tensor<2x3xf32>, %arg1: tensor<3x4xf32>) -> tensor<2x4xf32> {
        %0 = "stablehlo.dot_general"(%arg0, %arg1) {
          dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1],
                                                   rhs_contracting_dimensions = [0]>,
          precision_config = [#stablehlo<precision DEFAULT>, #stablehlo<precision DEFAULT>]
        } : (tensor<2x3xf32>, tensor<3x4xf32>) -> tensor<2x4xf32>
        func.return %0 : tensor<2x4xf32>
      }
    }
    """
  end

  @doc """
  Convolution operation.
  """
  def convolution do
    """
    module {
      func.func @main(%arg0: tensor<1x28x28x1xf32>, %arg1: tensor<3x3x1x32xf32>) -> tensor<1x26x26x32xf32> {
        %0 = "stablehlo.convolution"(%arg0, %arg1) {
          window_strides = array<i64: 1, 1>,
          padding = array<i64: 0, 0, 0, 0>,
          lhs_dilation = array<i64: 1, 1>,
          rhs_dilation = array<i64: 1, 1>,
          dimension_numbers = #stablehlo.conv<[b, 0, 1, f]x[0, 1, i, o]->[b, 0, 1, f]>,
          feature_group_count = 1 : i64,
          batch_group_count = 1 : i64,
          precision_config = [#stablehlo<precision DEFAULT>, #stablehlo<precision DEFAULT>]
        } : (tensor<1x28x28x1xf32>, tensor<3x3x1x32xf32>) -> tensor<1x26x26x32xf32>
        func.return %0 : tensor<1x26x26x32xf32>
      }
    }
    """
  end

  @doc """
  Reduce operation.
  """
  def reduce do
    """
    module {
      func.func @main(%arg0: tensor<4x8xf32>) -> tensor<4xf32> {
        %0 = "stablehlo.reduce"(%arg0) ({
          ^bb0(%arg1: tensor<f32>, %arg2: tensor<f32>):
            %1 = stablehlo.add %arg1, %arg2 : tensor<f32>
            stablehlo.return %1 : tensor<f32>
        }) {
          dimensions = array<i64: 1>
        } : (tensor<4x8xf32>) -> tensor<4xf32>
        func.return %0 : tensor<4xf32>
      }
    }
    """
  end

  @doc """
  While loop operation.
  Source: thirdparty/stablehlo/stablehlo/tests/interpret/while.mlir
  """
  def while_loop do
    """
    module {
      func.func @main(%arg0: tensor<i32>) -> tensor<i32> {
        %0 = stablehlo.while (%arg1 = %arg0) : (tensor<i32>) -> tensor<i32> {
          %1 = stablehlo.constant dense<10> : tensor<i32>
          %2 = stablehlo.compare LT, %arg1, %1, SIGNED : (tensor<i32>, tensor<i32>) -> tensor<i1>
          stablehlo.return %2 : tensor<i1>
        } do {
          %1 = stablehlo.constant dense<1> : tensor<i32>
          %2 = stablehlo.add %arg1, %1 : tensor<i32>
          stablehlo.return %2 : tensor<i32>
        }
        func.return %0 : tensor<i32>
      }
    }
    """
  end

  @doc """
  Conditional (if) operation.
  Source: thirdparty/stablehlo/stablehlo/tests/interpret/if.mlir
  """
  def conditional do
    """
    module {
      func.func @main(%arg0: tensor<i1>, %arg1: tensor<f32>, %arg2: tensor<f32>) -> tensor<f32> {
        %0 = stablehlo.if %arg0 -> (tensor<f32>) {
          %1 = stablehlo.multiply %arg1, %arg1 : tensor<f32>
          stablehlo.return %1 : tensor<f32>
        } else {
          %1 = stablehlo.add %arg2, %arg2 : tensor<f32>
          stablehlo.return %1 : tensor<f32>
        }
        func.return %0 : tensor<f32>
      }
    }
    """
  end

  @doc """
  Get dimension size operation.
  Source: thirdparty/stablehlo/stablehlo/tests/interpret/get_dimension_size.mlir
  """
  def get_dimension_size do
    """
    module {
      func.func @main(%arg0: tensor<?xf32>) -> tensor<i32> {
        %0 = stablehlo.get_dimension_size %arg0, dim = 0 : (tensor<?xf32>) -> tensor<i32>
        func.return %0 : tensor<i32>
      }
    }
    """
  end

  @doc """
  Returns a list of all available text fixtures.
  """
  def all do
    [
      {:simple_add, simple_add()},
      {:reverse_tensor, reverse_tensor()},
      {:dynamic_slice, dynamic_slice()},
      {:constant_dense, constant_dense()},
      {:dot_general, dot_general()},
      {:convolution, convolution()},
      {:reduce, reduce()},
      {:while_loop, while_loop()},
      {:conditional, conditional()},
      {:get_dimension_size, get_dimension_size()}
    ]
  end
end

