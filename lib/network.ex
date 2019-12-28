defmodule Tapestry.Network do
  #{:ok, pid} = GenServer.start_link(Tapestry.Manager, {12,5})
  def createNodeIDs(numNodes) do
    #Get hex ids from node count
    globalNodeList = Enum.to_list(1..numNodes)
    globalNodeList = Enum.map(globalNodeList, fn n ->
      id = id_from_num(to_string(n))
    end)
    globalNodeList
  end

  defp id_from_num(num) do
    #inputs: num is a string
    :crypto.hash(:sha, num) |> Base.encode16 |> String.slice(0..7)
  end

  def createAllRoutingTables(allTables, [], _globalNodeList), do: allTables
  def createAllRoutingTables(allTables, [currNode | tail], globalNodeList) do
    blankTable = createRoutingTable()
    routingTable = addNodesToTable(blankTable, currNode, globalNodeList)

    allTables = allTables ++ [routingTable]

    #recursive call for next node's table
    createAllRoutingTables(allTables, tail, globalNodeList)
  end

  #used for iterating over the list of Node IDs
  def addNodesToTable(routingTable, _currentNode, []), do: routingTable
  def addNodesToTable(routingTable, currentNode, [nodeToAdd | tail]) do

    currentNodeID = elem(currentNode, 0)
    nodeIDToAdd = elem(nodeToAdd, 0)
    levelToPutInTable = Tapestry.Helper.commonPrefix([currentNodeID, nodeIDToAdd])

    columnToPutInTable = String.at(nodeIDToAdd, levelToPutInTable)
    #Convert hex digit string to integer
    columnToPutInTable = Tapestry.Helper.stringHexToInt(columnToPutInTable)

    routingTable = insertID(routingTable, nodeToAdd, levelToPutInTable + 1, columnToPutInTable)

    addNodesToTable(routingTable, currentNode, tail)
    # require IEx; IEx.pry

  end

  def insertID(routingTable, id, level, column) do
    #inputs: "routingTable" to add the "id" to at "level" and "column"

    valueEmpty = (routingTable[level][column] == nil)
    if valueEmpty do #add it since it's
      put_in(routingTable, [level, column], id)
    else
      routingTable
    end
  end

  def createRoutingTable do
    #base 16, 8 levels
    %{
      1 => %{ # level 1
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      2 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      3 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      4 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      5 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      6 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      7 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      },
      8 => %{
        0 => nil,
        1 => nil,
        2 => nil,
        3 => nil,
        4 => nil,
        5 => nil,
        6 => nil,
        7 => nil,
        8 => nil,
        9 => nil,
        0xA => nil,
        0xB => nil,
        0xC => nil,
        0xD => nil,
        0xE => nil,
        0xF => nil
      }
    }
  end

end
