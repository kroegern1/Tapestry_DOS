defmodule Tapestry.Helper do

  def generate_requests(list, number) do
    generate_requests(list, number, 0, [])
  end

  def generate_requests(_list, number, current, output) when current == number do
    output
  end

  def generate_requests(list, number, current, output) do
    new_output = output ++ [{Enum.random(list), Enum.random(list)}]
    generate_requests(list, number, current + 1, new_output)
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

end
