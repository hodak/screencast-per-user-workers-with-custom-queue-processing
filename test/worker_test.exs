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
    assert [:hodor] == Restaurant.Worker.call_action(pid, action, :hodor)
  end

  test "it squashes actions and calls handler with multiple arguments", %{worker_pid: pid} do
    self_pid = self
    action = fn(x) -> send self_pid, x end
    Enum.each([:a, :b], fn(arg) -> spawn fn -> Restaurant.Worker.call_action(pid, action, arg) end end)
    assert_receive [:a, :b]
  end

  test "it only squashes actions with the same handler", %{worker_pid: pid} do
    self_pid = self
    a1 = fn(args) -> send self_pid, args end
    a2 = fn(args) -> send self_pid, args end
    [{a1, :a}, {a2, :b}, {a1, :c}, {a2, :d}]
    |> Enum.each(fn({handler, arg}) -> spawn fn -> Restaurant.Worker.call_action(pid, handler, arg) end end)
    assert_receive [:a, :c]
    assert_receive [:b, :d]
  end
end
