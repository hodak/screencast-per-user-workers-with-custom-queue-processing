defmodule Restaurant.WorkerTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Restaurant.Worker.start_link
    [worker_pid: pid]
  end

  test "it runs an action and returns its result", %{worker_pid: pid} do
    action = fn(_) -> :ok end
    assert :ok == Restaurant.Worker.call_action(pid, action)
  end

  test "it runs an action with an argument", %{worker_pid: pid} do
    action = fn(x) -> x end
    assert :hodor == Restaurant.Worker.call_action(pid, action, :hodor)
  end
end
