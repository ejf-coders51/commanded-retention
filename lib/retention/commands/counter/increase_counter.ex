defmodule Retention.Commands.Counter.IncreaseCounter do
  @enforce_keys [:counter_id]
  defstruct [
    :counter_id
  ]
end
