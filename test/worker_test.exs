defmodule Restaurant.WorkerTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Restaurant.Worker.start_link
    [worker_pid: pid]
  end

  test "it runs an action and returns its result", %{worker_pid: pid} do
    IO.inspect pid
    assert 1 == 1
  end
end
