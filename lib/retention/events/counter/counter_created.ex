defmodule Retention.Events.Counter.CounterCreated do
  @moduledoc """
  CounterCreated event.
  """
  @derive Jason.Encoder
  defstruct [
    :counter_id,
    :value
  ]
end
