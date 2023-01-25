defmodule Retention.Commands.Counter.CreateCounter do
  @enforce_keys [:counter_id]
  defstruct [
    :counter_id,
    :value
  ]
end
