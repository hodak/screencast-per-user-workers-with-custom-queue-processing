defmodule Restaurant.Worker do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def call_action(pid, action_handler, argument \\ nil) do
    GenServer.call(pid, {:call_action, action_handler, argument})
  end

  def handle_call({:call_action, action_handler, argument}, from, actions) do
    Process.send_after(self, :try_running, 0)
    action = {action_handler, argument, from}
    {:noreply, [action | actions]}
  end

  def handle_info(:try_running, []) do
    {:noreply, []}
  end

  def handle_info(:try_running, [{action_handler, _, _} | _] = actions) do
    relevant_action? = fn({handler, _, _}) -> handler == action_handler end
    relevant_actions = Enum.filter(actions, relevant_action?)

    arguments = Enum.map(relevant_actions, fn({_, arg, _}) -> arg end) |> Enum.reverse
    response = action_handler.(arguments)
    Enum.each(relevant_actions, fn({_, _, from}) -> GenServer.reply(from, response) end)

    {:noreply, Enum.reject(actions, relevant_action?)}
  end
end
