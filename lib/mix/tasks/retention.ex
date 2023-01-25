defmodule Mix.Tasks.Retention do
  use Mix.Task

  alias Retention.Commands.Counter.{CreateCounter, IncreaseCounter, SnapshotCounter}

  def run(_args) do
    Logger.configure(level: :error)

    counter_id = UUID.uuid4()
    Retention.App.dispatch(%CreateCounter{counter_id: counter_id, value: 1})

    increment(counter_id, 9)

    triggerRetention(counter_id)

    replay_projection("counters", ["counters"])

    increment(counter_id, 2)
  end

  def replay_projection(projection_name, tables) do
    config = Retention.Repo.config()
    config = Keyword.put(config, :pool_size, 2)
    {:ok, conn} = Postgrex.start_link(config)

    truncate_tables(conn, tables)
    delete_projection_versions(conn, projection_name)

    config = Retention.EventStore.config()
    config = Keyword.put(config, :pool_size, 2)
    {:ok, conn} = Postgrex.start_link(config)

    reset_subscription(conn, projection_name)
    restart_supervisor("Retention.EventHandlerSupervisor")
  end

  defp truncate_tables(conn, tables) do
    Enum.map(tables, fn table -> Postgrex.query!(conn, "TRUNCATE TABLE #{table} CASCADE;", []) end)
  end

  defp delete_projection_versions(conn, projection_module) do
    Postgrex.query!(
      conn,
      "DELETE FROM projection_versions WHERE projection_name='#{projection_module}';",
      []
    )
  end

  defp reset_subscription(conn, projection_module) do
    Postgrex.query!(
      conn,
      "UPDATE subscriptions SET last_seen=0 WHERE subscription_name = '#{projection_module}';",
      []
    )
  end

  defp restart_supervisor(projector_supervisor) do
    String.to_atom("Elixir." <> projector_supervisor) |> Process.whereis() |> Process.exit(:kill)
    Process.sleep(5000)
  end

  defp increment(counter_id, no) do
    Enum.each(1..no, fn _x ->
      Retention.App.dispatch(%IncreaseCounter{counter_id: counter_id})
    end)
  end

  def triggerRetention(counter_id) do
    Retention.App.dispatch(%SnapshotCounter{counter_id: counter_id}, consistency: :strong)
    delete_old_events(counter_id)
  end

  def delete_old_events(counter_id) do
    config = Retention.EventStore.config()
    config = Keyword.put(config, :pool_size, 2)
    {:ok, conn} = Postgrex.start_link(config)

    Postgrex.query!(
      conn,
      " delete
        from stream_events
        where event_id in (
          select e.event_id
          from events e
          join stream_events se
            on e.event_id = se.event_id
          join streams s
            on s.stream_id = se.stream_id
        where s.stream_uuid = '#{counter_id}'
        and e.event_type <> 'Counter.CounterSnapshotCreated'
        );",
      []
    )

    Postgrex.query!(
      conn,
      "delete
      from events e
      where e.event_id not in (select event_id	from stream_events se);",
      []
    )
  end
end
