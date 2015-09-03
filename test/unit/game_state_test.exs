defmodule GameStateTest do
  use ExUnit.Case
  alias Two48.GameState

  test "it moves a number to the left" do
    state = %GameState{
      board: [
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, nil, nil],
        [nil, nil, 2, nil]
      ]
    }
    |> GameState.move_left

    assert state.board |> Enum.at(3) == [2, nil, nil, nil]
  end
end
