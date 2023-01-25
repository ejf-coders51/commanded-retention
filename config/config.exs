import Config

config :retention,
  ecto_repos: [Retention.Repo],
  event_stores: [Retention.EventStore]

config :retention, Retention.Repo, migration_source: "ecto_migrations"

config :commanded, type_provider: Retention.TypeProvider

config :retention, Retention.App,
  snapshotting: %{
    Retention.Aggregates.Counter => [
      snapshot_every: 5,
      snapshot_version: 1
    ]
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
