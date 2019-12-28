#mix run tapestry.exs 10 20

defmodule Run do
  def checkAlive(pid) do
    if Process.alive?(pid) do
      checkAlive(pid)
    else
      nil
    end
  end
end

case length(System.argv) do
  2 ->
    [numNodes, numRequests] = Enum.map(System.argv(), &String.to_integer(&1))
    {:ok, pid} = GenServer.start_link(Tapestry.Manager, {numNodes,numRequests}, name: Tapestry.Manager)
    Run.checkAlive(pid)
  _ -> IO.puts("Too few / too many arguments.")
end

