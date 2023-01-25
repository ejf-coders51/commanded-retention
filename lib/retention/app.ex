defmodule Retention.App do
  @moduledoc false

  use Commanded.Application,
    otp_app: :retention,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: Retention.EventStore
    ]

  router(Retention.Router)
end
