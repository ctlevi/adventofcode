defmodule Day3 do
  def houses_covered(directions, start) do
    Enum.scan(directions, start, &where_to/2)
    |> Enum.uniq
    |> length
  end

  def where_to(direction, house_number) do
    {addX, addY} = case direction do
      ?^ -> {0, 1}
      ?v -> {0, -1}
      ?> -> {1, 0}
      ?< -> {-1, 0}
      _ -> {0, 0}
    end
    {x, y} = house_number
    {x + addX, y + addY}
  end
end

{:ok, input} = File.read("input/day3.txt")
directions = to_char_list(input)
IO.inspect Day3.houses_covered(directions, {0, 0})
