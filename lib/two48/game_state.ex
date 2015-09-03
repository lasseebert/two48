defmodule Two48.GameState do
  defstruct(
    board: List.duplicate(nil, 4) |> List.duplicate(4),
    score: 0
  )

  def new do
    %Two48.GameState{}
  end

  def move_left(state) do
    {board, score} = move_rows_left(state.board)
    %{ state | board: board, score: state.score + score }
  end

  def move_right(state) do
    {board, score} = state.board
            |> Enum.map(&Enum.reverse/1)
            |> move_rows_left
    board = board |> Enum.map(&Enum.reverse/1)
    %{ state | board: board, score: state.score + score }
  end

  def move_up(state) do
    {board, score} = state.board
            |> rotate_left
            |> move_rows_left
    board = board |> rotate_right
    %{ state | board: board, score: state.score + score }
  end

  def move_down(state) do
    {board, score} = state.board
            |> rotate_right
            |> move_rows_left
    board = board |> rotate_left
    %{ state | board: board, score: state.score + score }
  end

  defp move_rows_left(list), do: move_rows_left(list, [], 0)
  defp move_rows_left([], result, score), do: { Enum.reverse(result), score }
  defp move_rows_left([head | tail], result, score) do
    {row, new_score} = move_row_left(head)
    move_rows_left(tail, [row | result], score + new_score)
  end

  defp move_row_left(row) do
    { row, score } = row
    |> remove_nils
    |> merge

    row = fill_nils_right(row)
    {row, score}
  end

  defp remove_nils(list) do
    Enum.filter(list, &(&1))
  end

  defp merge(list), do: merge(list, [], 0)
  defp merge([], result, score), do: {Enum.reverse(result), score}
  defp merge([a, a | tail], result, score), do: merge(tail, [a * 2 | result], score + a * 2)
  defp merge([a | tail], result, score), do: merge(tail, [a | result], score)

  defp fill_nils_right(list), do: fill_nils_right(Enum.reverse(list), 4 - length(list))
  defp fill_nils_right(list, 0), do: Enum.reverse(list)
  defp fill_nils_right(list, n), do: fill_nils_right([nil | list], n - 1)

  defp rotate_left(matrix), do: rotate_left(matrix, [])
  defp rotate_left([[] | tail], result), do: result
  defp rotate_left(matrix, result) do
    row = matrix |> Enum.map(&hd/1)
    matrix = matrix |> Enum.map(&tl/1)
    rotate_left(matrix, [row | result])
  end

  defp rotate_right(matrix) do
    matrix
    |> rotate_left
    |> rotate_left
    |> rotate_left
  end
end
