defmodule Challenges.CacheWrapper do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(arg) do
    :ets.new(:thin, [
      :set,
      :public,
      :named_table,
      {:read_concurrency, true},
      {:write_concurrency, true}
    ])

    {:ok, arg}
  end

  def get(key) do
    case :ets.lookup(:thin, key) do
      [] ->
        nil

      [{_key, value}] ->
        value
    end
  end

  def put(key, value), do: :ets.insert(:thin, {key, value})

  def get_or_create(key, func) do
    case get(key) do
      nil ->
        result = func.()
        put(key, result)
        result

      value ->
        value
    end
  end
end
