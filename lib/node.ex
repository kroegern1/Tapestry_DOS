defmodule Tapestry.Node do
  use GenServer

  # STATE
  # ====================
  # id         the hashed id of the node
  # map        the neighbor map, with B entries in N levels

  # CLIENT API
  # ===================================

  def start_link({id, map}) do
    GenServer.start_link(__MODULE__, {id, map})
  end

  # SERVER API
  # ===================================
  def init({id, map}) do
    {:ok, {id, map}}
  end

  def handle_cast({:route, hops, origin, destination}, {id, map}) do
    {nid, _pid} = id

    cond do
      destination == nid ->
        # IO.puts("routed to #{nid}")
        GenServer.cast(Tapestry.Manager, {:routed, hops})

      true ->
        level = Tapestry.Helper.commonPrefix([destination, nid])
        index = String.slice(destination, level..level) |> Tapestry.Helper.stringHexToInt()
        {_next, pid} = map[level + 1][index]
        # IO.puts("Routing from #{nid} to #{next}. Destination: #{destination}")
        GenServer.cast(pid, {:route, hops + 1, origin, destination})
    end

    {:noreply, {id, map}}
  end

  def handle_call({:update, {id, map}}, _from, {_, _}) do
    {:reply, :ok, {id, map}}
  end

  def handle_call({:join, node_list, current}, _from, {_id, _map}) do
    blank = Tapestry.Network.createRoutingTable()
    new_map = Tapestry.Network.addNodesToTable(blank, current, node_list)

    Enum.each(new_map, fn {_level, row} ->
      Enum.each(row, fn {_index, node} ->
        cond do
          node == nil ->
            nil

          true ->
            {_nid, pid} = node
            GenServer.call(pid, {:add_node, current})
        end
      end)
    end)

    {:reply, :ok, {current, new_map}}
  end

  def handle_call({:add_node, new_node}, _from, {id, map}) do
    new_map = Tapestry.Network.addNodesToTable(map, id, [new_node])
    {:reply, :ok, {id, new_map}}
  end
end

# ignore these, old comments
# directory  list of pointers towards objects stored in other nodes (not used)
# store      map of objects stored at this node (not used)
