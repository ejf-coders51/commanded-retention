defmodule Retention.Router do
  @moduledoc false

  use Commanded.Commands.Router

  alias Retention.Commands.Counter.{CreateCounter, IncreaseCounter, SnapshotCounter}

  alias Retention.Aggregates.Counter

  identify(Counter, by: :counter_id)

  dispatch([CreateCounter, IncreaseCounter, SnapshotCounter], to: Counter)
end
