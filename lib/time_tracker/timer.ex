defmodule TimeTracker.Timer do
  use GenServer

  def start do
    GenServer.start_link(__MODULE__, nil)
  end

  def stop(pid) do
    GenServer.call(pid, :stop)
  end

  @impl true
  def init(_) do
    {:ok, %{start_time: System.system_time(:second), running: true}}
  end

  @impl true
  def handle_call(:stop, _from, state) do
    if state.running do
      current_time = System.system_time(:second)
      elapsed = current_time - state.start_time
      {:reply, elapsed, %{state | running: false}}
    else
      {:reply, {:error, :already_stopped}, state}
    end
  end
end
