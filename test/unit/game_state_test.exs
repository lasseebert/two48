defmodule GameStateTest do
  use ExUnit.Case
  alias Two48.GameState

  @board_1 %GameState{
    board: [
      [nil, nil, nil, nil],
      [nil, nil, nil, nil],
      [nil, nil, 2, nil],
      [nil, nil, nil, nil]
    ]
  }

  @board_2 %GameState{
    board: [
      [nil, nil, nil, nil],
      [nil, nil, nil, nil],
      [2, nil, 2, nil],
      [nil, nil, nil, nil]
    ]
  }

  @board_3 %GameState{
    board: [
      [nil, nil, nil, nil],
      [nil, nil, nil, nil],
      [2, 2, 2, nil],
      [nil, nil, nil, nil]
    ]
  }

  test "it can set and get a spcific field" do
    field = GameState.new |> GameState.set({0, 3}, 32) |> GameState.get({0, 3})
    assert field == 32
  end

  test "it moves a number left" do
    state = @board_1 |> GameState.move(:left)
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it moves a number right" do
    state = @board_1 |> GameState.move(:right)
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil]
  end

  test "it moves a number up" do
    state = @board_1 |> GameState.move(:up)
    assert state.board |> List.flatten == [nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it moves a number down" do
    state = @board_1 |> GameState.move(:down)
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil]
  end

  test "it merges two numbers" do
    state = @board_2 |> GameState.move(:left)
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 4, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it merges the right numbers" do
    state = @board_3 |> GameState.move(:left)
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 4, 2, nil, nil, nil, nil, nil, nil]
  end

  test "it adds to score when merging" do
    state = @board_2 |> GameState.move(:left)
    assert state.score == 4
  end
end
