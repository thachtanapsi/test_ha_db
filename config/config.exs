import Config

config :test_ha_db,
  ecto_repos: [TestHaDb.Repo]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
