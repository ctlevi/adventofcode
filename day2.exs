defmodule Day2 do
  def total_packaging(boxes) do
    boxes
    |> Enum.map(&packaging(&1))
    |> Enum.reduce(fn {paper, bow}, {acc_paper, acc_bow} -> {acc_paper + paper, acc_bow + bow} end)
  end

  def packaging(box) do
    [l, w, h] = box
    [side1, side2, side3] = [l * w, w * h, h * l]
    [perimeter1, perimeter2, perimeter3] = [l + w, w + h, h + l]
    smallest_side_area = min(side1, side2) |> min(side3)
    smallest_perimeter = min(perimeter1, perimeter2) |> min(perimeter3)
    paper = (2 * side1) + (2 * side2) + (2 * side3) + smallest_side_area
    bow = (l * w * h) + (smallest_perimeter * 2)
    {paper, bow}
  end
end

{:ok, input} = File.read("input/day2.txt")
parsed_boxes = input
  |> String.split("\n")
  |> Enum.map(fn box -> String.split(box, "x") |> Enum.map(fn dim -> String.to_integer(dim) end) end)


IO.inspect Day2.total_packaging(parsed_boxes)
