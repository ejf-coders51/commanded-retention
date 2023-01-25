defmodule Retention.Repo.Migrations.DropTrigger do
  use Ecto.Migration

  def change do
    execute("drop trigger no_delete_events on events;")
    execute("drop trigger no_delete_stream_events on stream_events;")
  end
end
