defmodule Restaurant.Handlers do
  def order(tables) do
    IO.puts "Waiter starts order for tables: " <> Enum.join(tables, ", ")
    :timer.sleep(5_000)
    IO.puts "Waiter finishes order for tables: " <> Enum.join(tables, ", ")
  end

  def bring_food(tables) do
    IO.puts "Waiter starts bringing food for tables: " <> Enum.join(tables, ", ")
    :timer.sleep(5_000)
    IO.puts "Waiter finishes bringing food for tables: " <> Enum.join(tables, ", ")
  end
end
