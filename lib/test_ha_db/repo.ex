defmodule TestHaDb.Repo do
  use Ecto.Repo,
    otp_app: :test_ha_db,
    adapter: Ecto.Adapters.Postgres
end
