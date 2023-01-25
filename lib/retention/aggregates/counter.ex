defmodule Retention.Aggregates.Counter do
  @moduledoc """
  Counter aggregate.
  """

  alias Retention.Events.Counter.{
    CounterCreated,
    CounterIncreased,
    CounterSnapshotCreated
  }

  alias Retention.Commands.Counter.{
    CreateCounter,
    IncreaseCounter,
    SnapshotCounter
  }

  alias Retention.Aggregates.Counter

  @derive Jason.Encoder
  defstruct [
    :counter_id,
    :value,
    :created_at
  ]

  def execute(
        %Counter{},
        %CreateCounter{counter_id: counter_id, value: value}
      ) do
    %CounterCreated{counter_id: counter_id, value: value}
  end

  def execute(
        %Counter{value: value},
        %IncreaseCounter{counter_id: counter_id}
      ) do
    %CounterIncreased{counter_id: counter_id, value: value + 1}
  end

  def execute(
        %Counter{value: value},
        %SnapshotCounter{counter_id: counter_id}
      ) do
    %CounterSnapshotCreated{counter_id: counter_id, value: value}
  end

  def apply(%Counter{}, %CounterCreated{
        counter_id: counter_id,
        value: value
      }) do
    %Counter{
      counter_id: counter_id,
      value: value
    }
  end

  def apply(%Counter{}, %CounterIncreased{
        counter_id: counter_id,
        value: value
      }) do
    %Counter{
      counter_id: counter_id,
      value: value
    }
  end

  def apply(%Counter{}, %CounterSnapshotCreated{
        counter_id: counter_id,
        value: value
      }) do
    %Counter{
      counter_id: counter_id,
      value: value
    }
  end
end
