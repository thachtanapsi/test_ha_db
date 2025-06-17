defmodule TestHaDb.Repo do
  use Ecto.Repo,
    otp_app: :test_ha_db,
    adapter: Ecto.Adapters.Postgres

    @max_retries 10
    @retry_delay 1000  # in ms

    def query_with_retry(fun, attempt \\ 1)

    def query_with_retry(fun, attempt) when attempt <= @max_retries do
      case fun.() do
        {:ok, result} ->
          if attempt > 1  do
            MessageLogWriter.log("retry #{attempt} success #{inspect(result)}")
          end
          {:ok, result}

        {:error, %DBConnection.ConnectionError{}} = result ->
          if attempt == @max_retries do
            MessageLogWriter.log(" --- max retries reached #{inspect(result)} --- ")
            result
          else
            Process.sleep(@retry_delay)
            query_with_retry(fun, attempt + 1)
          end

          result ->
            MessageLogWriter.log(" --- other error #{inspect(result)} --- ")
            result
      end
    end
end
