defmodule Restaurant.Pool do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def worker(pid, id) do
    GenServer.call(pid, {:worker, id})
  end

  def handle_call({:worker, id}, _from, workers) do
    worker = Map.get(workers, id)
    if worker && Process.alive?(worker) do
      {:reply, worker, workers}
    else
      {:ok, new_worker} = Restaurant.WorkerSupervisor.start_worker
      {:reply, new_worker, Map.put(workers, id, new_worker)}
    end
  end
end
