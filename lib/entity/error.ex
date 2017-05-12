defmodule Configurator.Entity.Error do
  @moduledoc """
  Error serializer
  """

  use Maru.Entity

  expose :error, [], fn(instance, _options) ->
    %{message: instance}
  end
end
