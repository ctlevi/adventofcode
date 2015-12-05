defmodule Day5 do
  def how_many_nice(words) do
    Enum.reduce(words, 0, fn (word, count) ->
      count + (if naughty_or_nice(word) == :nice, do: 1, else: 0)
    end)
  end

  defp naughty_or_nice(word) do
    if has_three_vowels(word) && has_repeating_letter(word) && all_allowed(word), do: :nice, else: :naughty
  end

  defp has_three_vowels(word) do
    Enum.reduce([?a, ?e, ?i, ?o, ?u], 0, fn (vowel, count) ->
      count + length(Enum.filter(word, fn letter -> letter == vowel end))
    end) >= 3
  end

  defp has_repeating_letter(word) do
    length(Enum.dedup(word)) < length(word)
  end

  defp all_allowed(word) do
    word_as_string = to_string(word)
    Enum.reduce(["ab", "cd", "pq", "xy"], true, fn (not_allowed, previous_check) ->
      previous_check && !String.contains?(word_as_string, not_allowed)
    end)
  end
end


{:ok, input} = File.read("input/day5.txt")
parsed_words = input
  |> String.split("\n")
  |> Enum.map(&to_char_list/1)

IO.inspect Day5.how_many_nice(parsed_words)
