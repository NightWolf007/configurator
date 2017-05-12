defmodule Configurator.Model.Config do
  @moduledoc """
  Config model
  """

  alias Configurator.Storage

  @type t :: %Configurator.Model.Config{}

  defstruct [:name, :service, data: %{}]

  @doc """
  Creates struct from Map with string keys
  """
  @spec new(Map.t) :: t
  def new(%{"name" => name, "service" => service, "data" => data}) do
    %Configurator.Model.Config{name: name, service: service, data: data}
  end

  @doc """
  Finds all configs for service
  """
  @spec find(String.t) :: list(t)
  def find(service) do
    key(service, "*")
    |> Storage.find_all()
    |> Enum.map(&new(&1))
  end

  @doc """
  Finds config in storage by service and name
  """
  @spec find(String.t, String.t) :: {:ok, t} | :error
  def find(service, name) do
    with {:ok, data} <- key(service, name) |> Storage.find() do
      {:ok, new(data)}
    end
  end

  @doc """
  Saves config into storage
  """
  @spec save(t) :: :ok | :error
  def save(%{name: name, service: service} = config) do
    Storage.save(key(service, name), config)
  end

  @doc """
  Removes config from storage
  """
  @spec delete(t) :: :ok | :error
  def delete(%{name: name, service: service}) do
    delete(service, name)
  end

  @doc """
  Removes config from storage by service and name
  """
  @spec delete(t) :: :ok | :error
  def delete(service, name) do
    Storage.delete(key(service, name))
  end

  defp key(service, name) do
    [service, name] |> Enum.join("_")
  end
end