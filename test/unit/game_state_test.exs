defmodule GameStateTest do
  use ExUnit.Case
  alias Two48.GameState

  @simple_board %GameState{
    board: [
      [nil, nil, nil, nil],
      [nil, nil, nil, nil],
      [nil, nil, nil, nil],
      [nil, nil, 2, nil]
    ]
  }

  test "it moves a number to the left" do
    state = @simple_board |> GameState.move_left
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2, nil, nil, nil]
  end

  test "it moves a number to the right" do
    state = @simple_board |> GameState.move_right
    assert state.board |> List.flatten == [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 2]
  end
end
