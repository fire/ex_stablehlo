defmodule Challenge37 do
  @moduledoc """
  (**) Calculate Euler's totient function phi(m) (improved).
  """
  def totient_phi_improved(m) do
    m
    |> Challenge36.prime_factors_mult()
    |> Enum.reduce(1, fn {px, mx}, acc ->
      acc * (px - 1) * px ** (mx - 1)
    end)
  end
end
