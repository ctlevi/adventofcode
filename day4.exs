defmodule Day4 do
  @key "ckczppom"

  def find_first_hash(matching) do
    Stream.iterate(1, &(&1 + 1))
    |> Stream.map(&hash(@key, &1))
    |> Enum.find_index(matching)
    |> + 1
  end

  defp hash(key, number), do: :crypto.hash(:md5, key <> to_string(number)) |> Base.encode16

  def match_5("00000" <> _), do: true
  def match_5(_), do: false

  def match_6("000000" <> _), do: true
  def match_6(_), do: false
end

IO.inspect Day4.find_first_hash(&Day4.match_5/1)
IO.inspect Day4.find_first_hash(&Day4.match_6/1)
