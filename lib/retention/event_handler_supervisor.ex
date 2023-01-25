defmodule Retention.EventHandlerSupervisor do
  use Supervisor

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    Supervisor.init(
      [
        Retention.View.Counter.CountersProjector
      ],
      strategy: :one_for_one
    )
  end
end
