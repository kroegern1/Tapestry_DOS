defmodule Example do
  #example for getting
  # map[1][11] is same as map[1][0xB]

  def testMain do
    numNodes = 1000

    globalNodeList = createNodeIDs(numNodes)
    IO.inspect globalNodeList

    #Populate the list of routing tables, corresponding to nodeIDs
    everyRoutingTable = createAllRoutingTables([], globalNodeList, globalNodeList)

    require IEx; IEx.pry

    everyRoutingTable
  end

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

  def createAllRoutingTables(allTables, [], globalNodeList), do: allTables
  def createAllRoutingTables(allTables, [currNode | tail], globalNodeList) do
    blankTable = createRoutingTable()
    routingTable = addNodesToTable(blankTable, currNode, globalNodeList)

    allTables = allTables ++ [routingTable]

    #recursive call for next node's table
    createAllRoutingTables(allTables, tail, globalNodeList)
  end

  #used for iterating over the list of Node IDs
  def addNodesToTable(routingTable, currentNode, []), do: routingTable
  def addNodesToTable(routingTable, currentNode, [nodeToAdd | tail]) do
    levelToPutInTable = commonPrefix([currentNode, nodeToAdd])

    columnToPutInTable = String.at(nodeToAdd, levelToPutInTable)
    #Convert hex digit string to integer
    columnToPutInTable = stringHexToInt(columnToPutInTable)

    routingTable = insertID(routingTable, nodeToAdd, levelToPutInTable + 1, columnToPutInTable)

    addNodesToTable(routingTable, currentNode, tail)
    # require IEx; IEx.pry

  end

  def stringHexToInt(stringInHex) do
    temp = Integer.parse(stringInHex, 16) |> Tuple.to_list
    int = Enum.at(temp, 0)
  end

  #adapted from https://rosettacode.org/wiki/Longest_common_prefix#Elixir
  def commonPrefix([]), do: ""
  def commonPrefix(ids) do
    #ids is a list of strings to compare
    # example: commonPrefix(["3BA5","3BA2"]) => 3
    if Enum.at(ids,0) == Enum.at(ids, 1) do
      0
    else
      min = Enum.min(ids)
      max = Enum.max(ids)
      index = Enum.find_index(0..String.length(min), fn i -> String.at(min,i) != String.at(max,i) end)
      if index, do: String.slice(min, 0, index), else: min
      index
    end
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

  def createFakeTable do
    routingTable = createRoutingTable()
    numNodes = 12
    nodes = Enum.to_list(1..numNodes)
    nodes = Enum.map(nodes, fn n ->
      id = id_from_num(to_string(n))
    end)

    #table for node 356A192B
    #add other nodes to its table
    routingTable = insertID(routingTable, Enum.at(nodes,0), 1, 3)
    routingTable = insertID(routingTable, Enum.at(nodes,1), 1, 0xD)
    routingTable = insertID(routingTable, Enum.at(nodes,2), 1, 7)
    routingTable = insertID(routingTable, Enum.at(nodes,3), 1, 1)
    routingTable = insertID(routingTable, Enum.at(nodes,4), 1, 0xA)
    routingTable = insertID(routingTable, Enum.at(nodes,5), 1, 0xC)

    routingTable = insertID(routingTable, Enum.at(nodes,6), 1, 9)
    routingTable = insertID(routingTable, Enum.at(nodes,7), 1, 0xF)
    routingTable = insertID(routingTable, Enum.at(nodes,8), 1, 0)
    routingTable = insertID(routingTable, Enum.at(nodes,9), 1, 0xB)

    routingTable = insertID(routingTable, Enum.at(nodes,10), 1, 1)#COLLISION! - "Do nothing, right?"
    routingTable = insertID(routingTable, Enum.at(nodes,11), 1, 7)#COLLISION! - "Do nothing, right?"

    IO.inspect(nodes)

    routingTable
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

  def createSmallTable do
    #Base 3, 2 levels - for testing purposes
    %{
      1 => %{ # level 1
        0 => nil,
        1 => nil,
        2 => nil
      },
      2 => %{ # level 2
        0 => nil,
        1 => nil,
        2 => nil
      }
    }
  end
end
