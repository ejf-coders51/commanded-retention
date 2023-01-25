defmodule Retention.Repo do
  use Ecto.Repo,
    otp_app: :retention,
    adapter: Ecto.Adapters.Postgres

  # Optional `init/2` function to modify config at runtime.
  def init(_type, config) do
    {:ok, config}
  end
end
