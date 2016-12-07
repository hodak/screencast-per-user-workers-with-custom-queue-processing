defmodule Restaurant.PoolTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = Restaurant.Pool.start_link
    [pool_pid: pid]
  end

  test "it responds with a worker", %{pool_pid: pid} do
    assert is_pid(Restaurant.Pool.worker(pid, "xxx"))
  end

  test "it responds with the same worker when asked twice with the same id", %{pool_pid: pid} do
    assert Restaurant.Pool.worker(pid, "xxx") == Restaurant.Pool.worker(pid, "xxx")
  end

  test "it responds with different workers when asked twice with different ids", %{pool_pid: pid} do
    assert Restaurant.Pool.worker(pid, "xxx") != Restaurant.Pool.worker(pid, "yyy")
  end
end
