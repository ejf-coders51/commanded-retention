defmodule Retention.Commands.Counter.SnapshotCounter do
  @enforce_keys [:counter_id]
  defstruct [
    :counter_id,
    :value
  ]
end
