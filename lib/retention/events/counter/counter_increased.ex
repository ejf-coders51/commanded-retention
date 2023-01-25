defmodule Retention.Events.Counter.CounterIncreased do
  @moduledoc """
  CounterCreated event.
  """
  @derive Jason.Encoder
  defstruct [
    :counter_id,
    :value
  ]
end
