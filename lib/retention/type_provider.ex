defmodule Retention.TypeProvider do
  @moduledoc false

  @behaviour Commanded.EventStore.TypeProvider

  @impl Commanded.EventStore.TypeProvider
  def to_string(struct) do
    struct.__struct__
    |> Atom.to_string()
    |> String.replace("Elixir.Retention.Events.", "")
  end

  @impl Commanded.EventStore.TypeProvider
  def to_struct(type) do
    "Elixir.Retention.Events.#{type}"
    |> String.to_atom()
    |> struct()
  end
end
