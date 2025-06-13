defmodule MessageLogWriter do
  use GenServer

  # 1 giây
  @flush_interval 1_000
  @batch_size 100
  # 10 MB
  @max_file_size 100 * 1024 * 1024

  def start_link(file_path) do
    GenServer.start_link(__MODULE__, %{file: file_path}, name: __MODULE__)
  end

  def log(message) do
    GenServer.cast(__MODULE__, {:log, message})
  end

  def init(state) do
    if !File.exists?(state.file) do
      File.touch!(state.file)
    end

    schedule_flush()
    {:ok, Map.put(state, :queue, [])}
  end

  def handle_cast({:log, message}, state) do
    {{year, month, day}, {hour, min, sec}} = :calendar.local_time()

    queue = [
      "#{year}-#{pad(month)}-#{pad(day)} #{pad(hour)}:#{pad(min)}:#{pad(sec)}: #{message}"
      | state.queue
    ]

    if length(queue) >= @batch_size do
      flush(queue, state.file)
      {:noreply, %{state | queue: []}}
    else
      {:noreply, %{state | queue: queue}}
    end
  end

  def handle_info(:flush, state) do
    if state.queue != [] do
      flush(state.queue, state.file)
    end

    maybe_rotate(state.file)
    schedule_flush()
    {:noreply, %{state | queue: []}}
  end

  defp flush(queue, file) do
    File.write!(file, (Enum.reverse(queue) |> Enum.join("\n")) <> "\n", [:append])
  end

  defp maybe_rotate(file) do
    {:ok, %{size: size}} = File.stat(file)

    if size >= @max_file_size do
      {{year, month, day}, {hour, min, sec}} = :calendar.local_time()

      rotated_file =
        "#{file}_#{year}#{pad(month)}#{pad(day)}_#{pad(hour)}#{pad(min)}#{pad(sec)}.log"

      File.rename(file, rotated_file)
      # create new empty file
      File.write!(file, "")
    end
  end

  defp schedule_flush do
    Process.send_after(self(), :flush, @flush_interval)
  end

  defp pad(num) when num < 10, do: "0#{num}"
  defp pad(num), do: "#{num}"
end
