defmodule Challenge34 do
  @moduledoc """
  (**) Calculate Euler's totient function phi(m).
    Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.
  """
  def totient_phi(m) do
    Enum.count(1..m, fn item ->
      Challenge33.coprime(m, item)
    end)
  end
end
