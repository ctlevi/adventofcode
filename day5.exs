defmodule Day5 do
  # Part 2 functions
  def how_many_nice_part_2(words) do
    Enum.reduce(words, 0, fn (word, count) ->
      count + (if naughty_or_nice_part_2(word) == :nice, do: 1, else: 0)
    end)
  end

  def naughty_or_nice_part_2(word) do
    if has_two_letters_repeating_twice?(word) && repeats_with_one_letter_between?(word), do: :nice, else: :naughty
  end

  def has_two_letters_repeating_twice?(word) do
    prepared_word = remove_exactly_three_in_a_row(word)
    all_pairs = Enum.chunk(prepared_word, 2) ++ Enum.chunk(tl(prepared_word), 2)
    length(Enum.uniq(all_pairs)) < length(all_pairs)
  end

  defp remove_exactly_three_in_a_row([h | rest = [h2 | [h3 | [ h4  | _]]]], previous \\ '') do
    if h == h2 && h == h3 && h != h4 && h != previous do
      remove_exactly_three_in_a_row(rest, h)
    else
      [h | remove_exactly_three_in_a_row(rest, h)]
    end
  end
  defp remove_exactly_three_in_a_row(rest = [h, h2, h3], previous), do: if h == h2 && h == h3 && h != previous, do: [h, h], else: rest
  defp remove_exactly_three_in_a_row(rest, previous), do: rest

  defp repeats_with_one_letter_between?(word) do
    if length(word) < 3 do
      false
    else
      Enum.zip(word, tl(word))
      |> Enum.zip(word |> tl |> tl)
      |> Enum.map(fn {{x, y}, z} -> [x, y, z] end)
      |> Enum.any?(fn [first, _, last] -> first == last end)
    end
  end

  # Part 1 functions
  def how_many_nice(words) do
    Enum.reduce(words, 0, fn (word, count) ->
      count + (if naughty_or_nice(word) == :nice, do: 1, else: 0)
    end)
  end

  defp naughty_or_nice(word) do
    if has_three_vowels?(word) && has_repeating_letter?(word) && all_allowed?(word), do: :nice, else: :naughty
  end

  defp has_three_vowels?(word) do
    Enum.reduce([?a, ?e, ?i, ?o, ?u], 0, fn (vowel, count) ->
      count + length(Enum.filter(word, fn letter -> letter == vowel end))
    end) >= 3
  end

  defp has_repeating_letter?(word) do
    length(Enum.dedup(word)) < length(word)
  end

  defp all_allowed?(word) do
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
IO.inspect Day5.how_many_nice_part_2(parsed_words)
