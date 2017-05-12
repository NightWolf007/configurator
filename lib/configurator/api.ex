defmodule Configurator.API do
  @moduledoc """
  API router
  """

  use Maru.Router

  alias Configurator.Entity.Error

  alias Maru.Exceptions.MatchError
  alias Maru.Exceptions.MethodNotAllowed
  alias Maru.Exceptions.NotFound
  alias Plug.Parsers.ParseError
  alias Maru.Exceptions.InvalidFormat

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:urlencoded, :json, :multipart]

  mount Configurator.API.Config

  rescue_from [MatchError, NotFound] do
    conn
    |> put_status(404)
    |> json(Error.serialize("not found"))
  end

  rescue_from MethodNotAllowed do
    conn
    |> put_status(405)
    |> json(Error.serialize("method not allowed"))
  end

  rescue_from [ParseError, InvalidFormat] do
    conn
    |> put_status(400)
    |> json(Error.serialize("bad request"))
  end

  rescue_from :all do
    conn
    |> put_status(500)
    |> json(Error.serialize("server error"))
  end
end
