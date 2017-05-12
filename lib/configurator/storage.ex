defmodule Configurator.Storage do
  @moduledoc """
  Common module for models
  """

  import Exredis.Api

  @doc """
  Finds data by pattern
  """
  @spec find_all(String.t) :: list(Map.t)
  def find_all(pattern) do
    pattern
    |> full_key()
    |> keys()
    |> Enum.map(&get(&1))
    |> Enum.map(&decode(&1))
  end

  @doc """
  Finds data by key
  """
  @spec find(String.t) :: {:ok, Map.t} | :error
  def find(key) do
    case key |> full_key() |> get() do
      :undefined -> :error
      data -> {:ok, decode(data)}
    end
  end

  @doc """
  Saves data by key
  """
  @spec save(String.t, Map.t) :: :ok | :error
  def save(key, data) do
    key |> full_key() |> set(encode(data))
  end

  @doc """
  Removes data by key
  """
  @spec delete(String.t) :: :ok | :error
  def delete(key) do
    if key |> full_key() |> del() > 0, do: :ok, else: :error
  end

  defp encode(data) do
    Poison.encode!(data)
  end

  defp decode(data) do
    Poison.decode!(data)
  end

  defp full_key(key) do
    [namespace(), key] |> Enum.join("_")
  end

  defp namespace do
    Application.get_env(:configurator, :namespace)
  end
end
