defmodule Restaurant.Pool do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def worker(pid, id) do
    GenServer.call(pid, {:worker, id})
  end

  def handle_call({:worker, id}, _from, workers) do
    case Map.get(workers, id) do
      nil ->
        {:ok, new_worker} = Restaurant.Worker.start_link
        {:reply, new_worker, Map.put(workers, id, new_worker)}
      worker ->
        {:reply, worker, workers}
    end
  end
end
