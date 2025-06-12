import Config

config :test_ha_db, TestHaDb.Repo,
username: "thachtan",
password: "postgres",
hostname: "localhost",
database: "gx_open",
stacktrace: true,
show_sensitive_data_on_connection_error: true,
pool_size: 2

config :test_ha_db,
  ecto_repos: [TestHaDb.Repo]
