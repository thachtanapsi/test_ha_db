import Config

config :test_ha_db, TestHaDb.Repo,
  database: "test_ha_db_test",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
