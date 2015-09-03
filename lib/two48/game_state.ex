defmodule Two48.GameState do
  defstruct board: List.duplicate(nil, 4) |> List.duplicate(4)

  def move_left(state) do
    board = move_rows_left(state.board)
    %{ state | board: board }
  end

  def move_right(state) do
    board = state.board
            |> Enum.map(&Enum.reverse/1)
            |> move_rows_left
            |> Enum.map(&Enum.reverse/1)
    %{ state | board: board }
  end

  defp move_rows_left(list), do: move_rows_left(list, [])
  defp move_rows_left([], acc), do: Enum.reverse(acc)
  defp move_rows_left([head | tail], acc) do
    move_rows_left(tail, [move_row_left(head) | acc])
  end

  defp move_row_left(row) do
    row
    |> remove_nils
    |> merge
    |> fill_nils_right
  end

  defp remove_nils(list) do
    Enum.filter(list, &(&1))
  end

  defp merge(list), do: merge(list, [])
  defp merge([], acc), do: Enum.reverse(acc)
  defp merge([a, a | tail], acc), do: merge(tail, [a * 2 | acc])
  defp merge([a | tail], acc), do: merge(tail, [a | acc])

  defp fill_nils_right(list), do: fill_nils_right(Enum.reverse(list), 4 - length(list))
  defp fill_nils_right(list, 0), do: Enum.reverse(list)
  defp fill_nils_right(list, n), do: fill_nils_right([nil | list], n - 1)
end
