defmodule Restaurant.WorkerSupervisor do
  use Supervisor

  @name Restaurant.WorkerSupervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: @name)
  end

  def start_worker do
    Supervisor.start_child(@name, [])
  end

  def init(:ok) do
    children = [
      worker(Restaurant.Worker, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
