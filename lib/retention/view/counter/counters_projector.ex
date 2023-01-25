defmodule Retention.View.Counter.CountersProjector do
  @moduledoc """
  Counter Projector.
  """

  use Commanded.Projections.Ecto,
    application: Retention.App,
    repo: Retention.Repo,
    name: "counters",
    start_from: :origin

  alias Retention.View.Counter.Counters

  alias Retention.Events.Counter.{
    CounterCreated,
    CounterIncreased,
    CounterSnapshotCreated
  }

  project(
    %CounterCreated{
      counter_id: counter_id,
      value: value
    },
    _metadata,
    fn multi ->
      multi
      |> Ecto.Multi.insert(
        :counters,
        %Counters{
          counter_id: counter_id,
          value: value
        }
      )
    end
  )

  project(
    %CounterSnapshotCreated{
      counter_id: counter_id,
      value: value
    },
    _metadata,
    fn multi ->
      multi
      |> Ecto.Multi.insert(
        :counters,
        %Counters{
          counter_id: counter_id,
          value: value
        },
        on_conflict: :replace_all,
        conflict_target: :counter_id
      )
    end
  )

  project(
    %CounterIncreased{
      counter_id: counter_id,
      value: value
    },
    _metadata,
    fn multi ->
      multi
      |> Ecto.Multi.run(:counter_to_update, fn _repo, _changes ->
        {:ok, Retention.Repo.get(Counters, counter_id)}
      end)
      |> Ecto.Multi.update(:games, fn %{counter_to_update: counter} ->
        Ecto.Changeset.change(counter, value: value)
      end)
    end
  )

  def error({:error, :failed}, %{}, _) do
    :skip
  end

  def error({:error, %Ecto.ConstraintError{}}, _event, _failure_context) do
    :skip
  end

  def error({:error, _error}, _event, _failure_context) do
    :skip
  end
end
