defmodule Day4 do
  @key "ckczppom"

  def find_first_hash() do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(&hash(@key, &1))
    |> Enum.find_index(&match/1)
    |> + 1
  end

  defp hash(key, number), do: :crypto.hash(:md5, key <> to_string(number)) |> Base.encode16

  defp match("00000" <> _), do: true
  defp match(_), do: false
end

IO.inspect Day4.find_first_hash()
