defmodule TenMilionSpamer.Supervisor do
  use Supervisor

  @num_child 5_000

  def start_link(_) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children =
      for i <- 1..@num_child do
        %{
          id: {:my_worker, i},
          start:
            {TenMilionSpamer.Worker, :start_link,
             [[id: i, name: String.to_atom("TenMilionSpamer.Worker_#{i}")]]},
          restart: :permanent,
          type: :worker
        }
      end

    # :one_for_one means if one child crashes, only that one is restarted.
    Supervisor.init(children, strategy: :one_for_one)
  end

  @doc """
  TenMilionSpamer.Supervisor.work
  """

  def work() do
    # File.stream!(File.cwd!() <> "/message_binary_check.txt")
    # File.stream!(File.cwd!() <> "/message_binary_check_copy.txt")
    1..1000000
    |> Stream.chunk_every(@num_child)
    |> Enum.each(fn batch ->
      batch
      |> Enum.with_index(fn element, index -> {index + 1, element} end)
      |> Enum.each(fn {id, _message} ->
        GenServer.cast(String.to_atom("TenMilionSpamer.Worker_#{id}"), {:store_message, "message"})
      end)
    end)
  end

  @doc """
  TenMilionSpamer.Supervisor.attack()
  """
  def attack() do
    Enum.each(1..@num_child, fn id ->
      GenServer.cast(String.to_atom("TenMilionSpamer.Worker_#{id}"), :attack)
    end)
  end
end
