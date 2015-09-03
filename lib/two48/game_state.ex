defmodule Two48.GameState do
  defstruct(
    board: List.duplicate(nil, 4) |> List.duplicate(4),
    score: 0
  )

  def new do
    %Two48.GameState{}
  end

  def move(state, direction) do
    state
    |> move_transform_before(direction)
    |> move_left
    |> move_transform_after(direction)
  end

  defp move_transform_before(state, :left),  do: state
  defp move_transform_before(state, :right), do: state |> mirror
  defp move_transform_before(state, :up),    do: state |> rotate_left
  defp move_transform_before(state, :down),  do: state |> rotate_right

  defp move_transform_after(state, :left),  do: state
  defp move_transform_after(state, :right), do: state |> mirror
  defp move_transform_after(state, :up),    do: state |> rotate_right
  defp move_transform_after(state, :down),  do: state |> rotate_left

  defp move_left(state) do
    {board, score} = state.board |> move_rows_left([], state.score)
    %{state | board: board, score: score}
  end
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

  defp mirror(state) do
    %{state | board: state.board |> Enum.map(&Enum.reverse/1)}
  end

  defp rotate_left(state), do: %{state | board: state.board |> rotate_left([])}
  defp rotate_left([[] | _tail], result), do: result
  defp rotate_left(matrix, result) do
    row = matrix |> Enum.map(&hd/1)
    matrix = matrix |> Enum.map(&tl/1)
    rotate_left(matrix, [row | result])
  end

  defp rotate_right(state) do
    state
    |> rotate_left
    |> rotate_left
    |> rotate_left
  end
end
