defmodule Tapestry.Manager do
  # GenServer.start_link(Tapestry.Manager, {100,10}, name: Tapestry.Manager)
  use GenServer

  def init({num_nodes, requests}) do
    # 80%
    initial = div(num_nodes * 4, 5)
    # 20%
    rest = num_nodes - initial

    nodeIDs = Tapestry.Network.createNodeIDs(num_nodes)
    pids = init_nodes(num_nodes)
    global_list = Enum.zip(nodeIDs, pids)

    initial_list = Enum.slice(global_list, 0, initial)
    waiting_list = Enum.slice(global_list, initial, rest + 1)

    initial_pids = Enum.slice(pids, 0, initial)

    tables = Tapestry.Network.createAllRoutingTables([], initial_list, initial_list)

    update_nodes(initial_list, tables, initial_pids)

    {:ok, {0, initial_list, requests}, {:continue, {:do_joins, waiting_list}}}
    # IO.inspect(global_list)
    # {:ok, {0, global_list}}
  end

  def handle_cast({:routed, result}, {longest, _global_list, received, total})
      when received == total - 1 do
    max_hops = max(longest, result)
    IO.puts("#{total} routes completed. Max hops: #{max_hops}")
    {:stop, :normal, []}
  end

  def handle_cast({:routed, result}, {longest, global_list, received, total}) do
    # IO.puts("#{received} out of #{total}")
    {:noreply, {max(longest, result), global_list, received + 1, total}}
  end

  def handle_cast({:do_routing, requests}, {longest, global_list, requests}) do
    routes = Tapestry.Helper.generate_requests(global_list, requests)
    # IO.inspect(routes)
    # require IEx; IEx.pry
    Enum.each(routes, fn
      {{_o_nid, o_pid}, {d_nid, _d_pid}} -> GenServer.cast(o_pid, {:route, 1, o_pid, d_nid})
    end)

    {:noreply, {longest, global_list, 0, requests}}
  end

  def handle_call(:get_state, _from, {longest, global_list}) do
    {:reply, {longest, global_list}, {longest, global_list}}
  end

  def handle_continue({:do_joins, waiting_list}, {longest, initial_list, requests}) do
    global_list = join_nodes(waiting_list, initial_list)
    GenServer.cast(self(), {:do_routing, requests})
    {:noreply, {longest, global_list, requests}}
  end

  def join_nodes(waiting_list, global_list) when waiting_list == [] do
    global_list
  end

  def join_nodes([current | rest], global_list) do
    {_nid, pid} = current
    GenServer.call(pid, {:join, global_list, current})
    join_nodes(rest, global_list ++ [current])
  end

  def init_nodes(number) do
    init_nodes(number, [])
  end

  def init_nodes(0, pids) do
    # IO.inspect(pids)
    pids
  end

  def init_nodes(number, pids) do
    {:ok, pid} = GenServer.start_link(Tapestry.Node, {0, 0})
    init_nodes(number - 1, pids ++ [pid])
  end

  def update_nodes([], [], []) do
    :ok
  end

  def update_nodes([id | ids], [map | maps], [pid | pids]) do
    # Set state for the pids
    :ok = GenServer.call(pid, {:update, {id, map}})
    update_nodes(ids, maps, pids)
  end
end
