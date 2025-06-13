defmodule TenMilionSpamer.Worker do
  use GenServer

  # localhost
  @target_ip {127, 0, 0, 1}
  @target_port 5_000

  def start_link(id: id, name: name) do
    GenServer.start_link(__MODULE__, [id: id, name: name], name: name)
  end

  def init(id: id, name: _name) do
    IO.puts("Worker #{id} started")
    {:ok, %{message: []}}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_info(:do_attack, %{message: []}) do
    {:noreply, %{message: []}}
  end

  def handle_info(:do_attack, %{message: [weapon | new_state]} = state) do
    # IO.puts("Worker #{weapon} attack")
    # continute attack per milisecond
    # SELECT account_id, context, active, id
    # FROM public.black_list;
    query = "INSERT INTO black_list (account_id, context, active) VALUES ($1, $2, $3)"
    TestHaDb.Repo.query(query, ["067C123456_#{weapon}", "c_#{weapon}", true], timeout: :infinity)
    Process.send_after(self(), :do_attack, 50)
    {:noreply, state |> Map.update(:message, [], fn _current -> new_state end)}
  end

  def handle_cast({:store_message, message}, state) do
    {:noreply, state |> Map.update(:message, [], fn current -> current ++ [message] end)}
  end

  def handle_cast(:attack, state) do
    Process.send(self(), :do_attack, [])
    {:noreply, state}
  end

  @doc """
    TenMilionSpamer.Worker.state(:"TenMilionSpamer.Worker_1")
  """
  def state(id) do
    GenServer.call(id, :state)
  end
end
