defmodule Configurator.API.Config do
  @moduledoc """
  Config router
  """

  use Maru.Router

  alias Configurator.Model.Config

  namespace :config do
    route_param :service, type: String do
      desc "Returns list of all configs"
      get do
        configs = Config.find(params[:service])
        conn
        |> put_status(200)
        |> json(configs)
      end
    end
  end
end