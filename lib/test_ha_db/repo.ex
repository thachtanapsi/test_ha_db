defmodule TestHaDb.Repo do
  use Ecto.Repo,
    otp_app: :test_ha_db,
    adapter: Ecto.Adapters.Postgres

    @max_retries 10
    @retry_delay 1000  # in ms

    def query_with_retry(fun, attempt \\ 1)

    def query_with_retry(fun, attempt) when attempt <= @max_retries do
      try do
        fun.()
      rescue
        e in DBConnection.ConnectionError ->  # <- adjust based on error type
          if attempt == @max_retries do
            raise e
          else
            Process.sleep(@retry_delay)
            query_with_retry(fun, attempt + 1)
          end
      end
    end
end
