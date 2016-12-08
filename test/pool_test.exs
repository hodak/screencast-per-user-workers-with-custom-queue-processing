defmodule Restaurant.PoolTest do
  use ExUnit.Case

  setup_all do
    Restaurant.WorkerSupervisor.start_link
    :ok
  end

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

  test "pool and other workers are not killed when one worker is killed", %{pool_pid: pid} do
    w1 = Restaurant.Pool.worker(pid, "xxx")
    w2 = Restaurant.Pool.worker(pid, "yyy")

    Process.exit(w1, :shutdown)
    ref = Process.monitor(w1)
    assert_receive {:DOWN, ^ref, _, _, _}

    assert Process.alive?(pid)
    assert Process.alive?(w2)
    refute Process.alive?(w1)

    assert w1 != Restaurant.Pool.worker(pid, "xxx")
    assert w2 == Restaurant.Pool.worker(pid, "yyy")
  end
end
