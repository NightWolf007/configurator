defmodule Configurator.API do
  @moduledoc """
  API router
  """

  use Maru.Router

  alias Maru.Exceptions.MatchError
  alias Maru.Exceptions.MethodNotAllowed
  alias Maru.Exceptions.NotFound
  alias Plug.Parsers.ParseError
  alias Maru.Exceptions.InvalidFormat

  before do
    plug Plug.Logger
  end

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:urlencoded, :json, :multipart]

  mount Configurator.API.Config

  rescue_from [MatchError, NotFound] do
    conn
    |> put_status(404)
    |> json(%{errors: [%{message: "not found"}]})
  end

  rescue_from MethodNotAllowed do
    conn
    |> put_status(405)
    |> json(%{errors: [%{message: "method not allowed"}]})
  end

  rescue_from [ParseError, InvalidFormat] do
    conn
    |> put_status(400)
    |> json(%{errors: [%{message: "bad request"}]})
  end

  rescue_from :all do
    conn
    |> put_status(500)
    |> json(%{errors: [%{message: "server error"}]})
  end
end
