defmodule Retention.Events.Counter.CounterSnapshotCreated do
  @moduledoc """
  SnapshotCreated event.
  """
  @derive Jason.Encoder
  defstruct [
    :counter_id,
    :value
  ]
end
