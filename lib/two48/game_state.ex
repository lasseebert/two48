defmodule Two48.GameState do
  @moduledoc """
  Functions to manipulate gamestate
  """

  defstruct board: nil, score: 0, size: nil

  @doc"""
  Creates a new empty gamestate
  """
  def new(size \\ 4) do
    %Two48.GameState{
      board: List.duplicate(nil, size) |> List.duplicate(size),
      size: size
    }
  end

  @doc """
  Sets a number on the board to the given value
  """
  def set(state, {row_index, column_index}, value) do
    row = state.board |> Enum.at(row_index)
                      |> List.replace_at(column_index, value)
    board = state.board |> List.replace_at(row_index, row)
    %{state | board: board}
  end

  @doc """
  Gets a number from the board
  """
  def get(state, {row_index, column_index}) do
    state.board
    |> Enum.at(row_index)
    |> Enum.at(column_index)
  end

  @doc """
  Answers if the given move can be made
  """
  def can_move?(state, direction) do
    state != move(state, direction)
  end

  @doc """
  Move in the given direction
  """
  def move(state, direction) do
    state
    |> move_transform(:before, direction)
    |> move_left
    |> move_transform(:after, direction)
  end

  @doc """
  True if no more moves can be made
  """
  def game_over?(state) do
    [:left, :right, :up, :down]
    |> Enum.all?(fn direction -> !can_move?(state, direction) end)
  end

  @doc """
  Places a 2 or 4 on a random tile
  """
  def place_random_number(state) do
    empty_fields = state.board
    |> List.flatten
    |> Enum.with_index
    |> Enum.reject(fn {value, _index} -> value end)
    |> Enum.map(fn {_value, index} -> index end)

    num_empty_fields = length(empty_fields)
    case num_empty_fields do
      0 -> state
      _ ->
        index  = Enum.at(empty_fields, :random.uniform(num_empty_fields) - 1)
        number = Enum.at([2, 4], :random.uniform(2) - 1)

        set(state, {div(index, state.size), rem(index, state.size)}, number)
    end
  end

  defp move_transform(state, _,       :left),  do: state
  defp move_transform(state, _,       :right), do: state |> mirror
  defp move_transform(state, :before, :up),    do: state |> rotate_left
  defp move_transform(state, :after,  :up),    do: state |> rotate_right
  defp move_transform(state, :before, :down),  do: state |> rotate_right
  defp move_transform(state, :after,  :down),  do: state |> rotate_left

  defp move_left(state) do
    {board, score} = state.board |> move_rows_left([], state.score)
    %{state | board: board, score: score}
  end

  defp mirror(state) do
    %{state | board: state.board |> Enum.map(&Enum.reverse/1)}
  end

  defp rotate_left(state), do: %{state | board: state.board |> rotate_left([])}
  defp rotate_left([[] | _tail], result), do: result
  defp rotate_left(matrix, result) do
    row    = matrix |> Enum.map(&hd/1)
    matrix = matrix |> Enum.map(&tl/1)
    rotate_left(matrix, [row | result])
  end

  defp rotate_right(state) do
    %{board: board} = rotate_left(state)
    board = board
            |> Enum.reverse
            |> Enum.map(&Enum.reverse/1)
    %{state | board: board}
  end

  defp move_rows_left([], result, score), do: { Enum.reverse(result), score }
  defp move_rows_left([head | tail], result, score) do
    {row, new_score} = move_row_left(head)
    move_rows_left(tail, [row | result], score + new_score)
  end

  defp move_row_left(row) do
    size = length(row)
    {row, score} = row
                    |> remove_nils
                    |> merge

    row = fill_nils_right(row, size - length(row))

    {row, score}
  end

  defp remove_nils(list) do
    Enum.filter(list, &(&1))
  end

  defp merge(list), do: merge(list, [], 0)
  defp merge([], result, score), do: {Enum.reverse(result), score}
  defp merge([a, a | tail], result, score) do
    merge(tail, [a * 2 | result], score + a * 2)
  end
  defp merge([a | tail], result, score) do
    merge(tail, [a | result], score)
  end

  defp fill_nils_right(list, n) do
    list ++ List.duplicate(nil, n)
  end
end
