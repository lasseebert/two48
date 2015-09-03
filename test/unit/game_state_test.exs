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

  test "it moves a number left" do
    state = @board_1 |> GameState.move_left
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it moves a number right" do
    state = @board_1 |> GameState.move_right
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil, nil]
  end

  test "it moves a number up" do
    state = @board_1 |> GameState.move_up
    assert state.board |> List.flatten == [nil, nil, 2, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it moves a number down" do
    state = @board_1 |> GameState.move_down
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil]
  end

  test "it merges two numbers" do
    state = @board_2 |> GameState.move_left
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 4, nil, nil, nil, nil, nil, nil, nil]
  end

  test "it merges the right numbers" do
    state = @board_3 |> GameState.move_left
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, 4, 2, nil, nil, nil, nil, nil, nil]
  end

  #test "it adds to score when merging" do
  #  state = @board_2 |> GameState.move_left
  #  assert state.score == 4
  #end
end
