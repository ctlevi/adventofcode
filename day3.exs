defmodule Day3 do
  # Part 1 entry
  def houses_covered_only_santa(directions, start) do
    houses_covered(directions, start) ++ [start]
    |> Enum.uniq
    |> length
  end

  # Part 2 entry
  def houses_covered_with_robo(directions, start) do
    %{0 => santa_directions, 1 => robo_santa_directions} = Enum.with_index(directions)
      |> Enum.group_by(fn {_, index} -> rem(index,2) end)
    # Group by reversed the list so I reverse it back after pulling the direction out of the tuple
    santa_directions = Enum.map(santa_directions, fn {direction, _} -> direction end) |> Enum.reverse
    robo_santa_directions = Enum.map(robo_santa_directions, fn {direction, _} -> direction end) |> Enum.reverse

    houses_covered(santa_directions, start) ++ houses_covered(robo_santa_directions, start) ++ [start]
    |> Enum.uniq
    |> length
  end

  defp houses_covered(directions, start), do: Enum.scan(directions, start, &where_to/2)

  defp where_to(direction, house_number) do
    {addX, addY} = case direction do
      ?^ -> {0, 1}
      ?v -> {0, -1}
      ?> -> {1, 0}
      ?< -> {-1, 0}
    end
    {x, y} = house_number
    {x + addX, y + addY}
  end
end

{:ok, input} = File.read("input/day3.txt")
directions = to_char_list(input)
IO.inspect Day3.houses_covered_only_santa(directions, {0, 0})
IO.inspect Day3.houses_covered_with_robo(directions, {0, 0})
