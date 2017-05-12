defmodule Configurator.API.Config do
  @moduledoc """
  Config router
  """

  use Maru.Router

  alias Configurator.Model.Config
  alias Configurator.Entity.Error

  namespace :configs do
    route_param :service, type: String do
      desc "Returns list of all configs"
      get do
        configs = Config.find(params[:service])
        conn |> put_status(200) |> json(configs)
      end

      route_param :name, type: String do
        desc "Returns config"
        get do
          case Config.find(params[:service], params[:name]) do
            {:ok, config} ->
              conn |> put_status(200) |> json(config)
            _ ->
              conn |> put_status(400) |> json(Error.serialize("not found"))
          end
        end

        desc "Creates config"
        params do
          requires :data, type: fn (x) -> x end
        end
        post do
          case Config.find(params[:service], params[:name]) do
            {:ok, _} ->
              conn |> put_status(400) |> json(Error.serialize("already exists"))
            _ ->
              config = build_config(params)
              Config.save(config)
              conn |> put_status(201) |> json(config)
          end
        end

        desc "Updates config"
        params do
          requires :data, type: fn (x) -> x end
        end
        put do
          case Config.find(params[:service], params[:name]) do
            {:ok, _} ->
              new_config = build_config(params)
              Config.save(new_config)
              conn |> put_status(200) |> json(new_config)
            _ ->
              conn |> put_status(400) |> json(Error.serialize("not found"))
          end
        end

        desc "Removes config"
        delete do
          case Config.find(params[:service], params[:name]) do
            {:ok, config} ->
              Config.delete(config)
              conn |> put_status(200) |> json(config)
            _ ->
              conn |> put_status(400) |> json(Error.serialize("not found"))
          end
        end
      end
    end
  end

  defp build_config(%{name: name, service: service, data: data}) do
    %Config{name: name, service: service, data: data}
  end
end
