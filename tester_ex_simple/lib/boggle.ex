defmodule Boggle do

  @moduledoc """
  Add your boggle function below. You may add additional helper functions if you desire.
  Test your code by running 'mix test' from the tester_ex_simple directory.
  """

  defstruct trie: %{} # is there an actual tree struct avail in elixir?

  # cant be pric bc test need
  def boggle(board, words) do
    trie = build_trie(words)
    Enum.reduce(0..(tuple_size(board) - 1), %{}, fn row_index, acc ->
      Enum.reduce(0..(tuple_size(elem(board, row_index)) - 1), acc, fn col_index, acc_inner ->
        do_boggle(board, {row_index, col_index}, trie, [], acc_inner)
      end)
    end)
  end

  defp build_trie(words) do
    Enum.reduce(words, %{}, fn word, acc ->
      insert_word(acc, String.graphemes(word))
    end)
  end

  defp insert_word(trie, []), do: Map.put(trie, :end, true)
  defp insert_word(trie, [head | tail]) do
    updated_trie = insert_word(Map.get(trie, head, %{}), tail)
    Map.put(trie, head, updated_trie)
  end

  # print output if needed for final sub
  defp do_boggle(board, {row, col}, trie, path, acc) do
    if valid_coord?(board, row, col) && {row, col} not in path do
      letter = elem(elem(board, row), col)
      updated_trie = trie[letter]

      if updated_trie do
        new_path = [{row, col} | path]

        new_acc =
        if updated_trie[:end] do
            word = Enum.reverse(new_path) |> Enum.map(fn {r, c} -> elem(elem(board, r), c) end) |> Enum.join()
            Map.put(acc, word, Enum.reverse(new_path))
        else
            acc
        end

        Enum.reduce(neighbors(row, col), new_acc, fn {n_row, n_col}, inner_acc ->
          do_boggle(board, {n_row, n_col}, updated_trie, new_path, inner_acc)
        end)
      else
        acc
      end
    else
      acc
    end
  end

  defp neighbors(row, col) do
    for dx <- -1..1, dy <- -1..1, dx != 0 or dy != 0, do: {row + dy, col + dx}
  end

  defp valid_coord?(board, row, col) do
    row >= 0 and row < tuple_size(board) and
    col >= 0 and col < tuple_size(elem(board, row))
  end
end
