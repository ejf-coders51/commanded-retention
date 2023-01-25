defmodule Retention.View.Counter.Counters do
  @moduledoc """
  Counter Projection
  """

  alias Retention.View.Counter.Counters

  use Ecto.Schema

  @primary_key {:counter_id, :string, autogenerate: false}
  schema "counters" do
    field(:value, :integer)
    timestamps()
  end

  def all() do
    Counters
    |> Retention.Repo.all()
  end

  def get(id) do
    Counters
    |> Retention.Repo.get(id)
    |> case do
      nil -> nil
      counter -> Map.get(counter, :value)
    end
  end
end
