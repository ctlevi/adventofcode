defmodule Day6.Part1 do
  @regex ~r/(?<command>\w*?\s?\w*) (?<top_x>\d*),(?<top_y>\d*) through (?<bottom_x>\d*),(?<bottom_y>\d*)/

  # Puts in instructions in the format {:command, {top_tuple}, {bottom_tuple}}
  def parse_instructions(instructions) do
    Enum.map instructions, fn instruction ->
      %{"command" => command, "top_x" => top_x, "top_y" => top_y, "bottom_x" => bottom_x, "bottom_y" => bottom_y} = Regex.named_captures(@regex, instruction)
      atom_command = String.replace(command, " ", "_") |> String.to_atom
      {atom_command, {String.to_integer(top_x), String.to_integer(top_y)}, {String.to_integer(bottom_x), String.to_integer(bottom_y)}}
    end
  end

  def total_on(instructions) do
    follow_instructions(instructions) |> Dict.values |> Enum.filter(&(&1 == true)) |> Enum.count
  end

  defp follow_instructions(instructions) do
    coordinates = Enum.flat_map 0..999, fn x ->
      Enum.map 0..999, fn y -> {x, y} end
    end
    lights = Enum.reduce coordinates, HashDict.new, fn coordinate, acc ->
      Dict.put(acc, coordinate, false)
    end

    Enum.reduce instructions, lights, fn {instruction, top, bottom}, lights ->
      change_lights(lights, instruction, top, bottom)
    end
  end

  defp change_lights(lights, instruction, {top_x, top_y}, {bottom_x, bottom_y}) do
    coordinates = Enum.flat_map top_x..bottom_x, fn x ->
      Enum.map top_y..bottom_y, fn y -> {x, y} end
    end
    Enum.reduce coordinates, lights, fn coordinate, lights ->
      Dict.update!(lights, coordinate, fn current -> handle_instruction(instruction, current) end)
    end
  end

  defp handle_instruction(:turn_on, _), do: true
  defp handle_instruction(:turn_off, _), do: false
  defp handle_instruction(:toggle, current), do: !current
end

defmodule Day6.Part2 do
  def total_brightness(instructions) do
    follow_instructions(instructions) |> Dict.values |> Enum.sum
  end

  defp follow_instructions(instructions) do
    coordinates = Enum.flat_map 0..999, fn x ->
      Enum.map 0..999, fn y -> {x, y} end
    end
    lights = Enum.reduce coordinates, HashDict.new, fn coordinate, acc ->
      Dict.put(acc, coordinate, 0)
    end

    Enum.reduce instructions, lights, fn {instruction, top, bottom}, lights ->
      change_lights(lights, instruction, top, bottom)
    end
  end

  defp change_lights(lights, instruction, {top_x, top_y}, {bottom_x, bottom_y}) do
    coordinates = Enum.flat_map top_x..bottom_x, fn x ->
      Enum.map top_y..bottom_y, fn y -> {x, y} end
    end
    Enum.reduce coordinates, lights, fn coordinate, lights ->
      Dict.update!(lights, coordinate, fn current -> handle_instruction(instruction, current) end)
    end
  end

  defp handle_instruction(:turn_on, current), do: current + 1
  defp handle_instruction(:turn_off, current), do: max(0, current - 1)
  defp handle_instruction(:toggle, current), do: current + 2
end

{:ok, input} = File.read("input/day6.txt")
parsed_instructions = input
  |> String.split("\n")
  |> Day6.Part1.parse_instructions

IO.inspect Day6.Part1.total_on(parsed_instructions)
IO.inspect Day6.Part2.total_brightness(parsed_instructions)
