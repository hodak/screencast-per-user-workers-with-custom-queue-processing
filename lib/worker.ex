defmodule Restaurant.Worker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def call_action(pid, action_handler, argument \\ nil) do
    GenServer.call(pid, {:call_action, action_handler, argument})
  end

  def handle_call({:call_action, action_handler, argument}, _from, actions) do
    response = action_handler.(argument)
    {:reply, response, actions}
  end
end
