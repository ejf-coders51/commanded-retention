import Config

config :retention, Retention.EventStore,
  username: "postgres",
  password: "postgres",
  database: "retention_dev",
  hostname: "localhost"

config :retention, Retention.Repo,
  username: "postgres",
  password: "postgres",
  database: "retention_dev",
  hostname: "localhost"
