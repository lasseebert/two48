defmodule GameStateTest do
  use ExUnit.Case
  alias Two48.GameState

  @board_1 GameState.new |> GameState.set({2, 2}, 2)
  @board_2 @board_1 |> GameState.set({2, 0}, 2)
  @board_3 @board_2 |> GameState.set({2, 1}, 2)

  test "it can set and get a spcific field" do
    field = GameState.new
            |> GameState.set({0, 3}, 32)
            |> GameState.get({0, 3})
    assert field == 32
  end

  test "it moves a number left" do
    state = @board_1 |> GameState.move(:left)
    assert state |> GameState.get({2, 0}) == 2
  end

  test "it moves a number right" do
    state = @board_1 |> GameState.move(:right)
    assert state |> GameState.get({2, 3}) == 2
  end

  test "it moves a number up" do
    state = @board_1 |> GameState.move(:up)
    assert state |> GameState.get({0, 2}) == 2
  end

  test "it moves a number down" do
    state = @board_1 |> GameState.move(:down)
    assert state |> GameState.get({3, 2}) == 2
  end

  test "it merges two numbers" do
    state = @board_2 |> GameState.move(:left)
    assert state |> GameState.get({2, 0}) == 4
  end

  test "it merges the right numbers" do
    state = @board_3 |> GameState.move(:left)
    assert state |> GameState.get({2, 0}) == 4
    assert state |> GameState.get({2, 1}) == 2
  end

  test "it adds to score when merging" do
    state = @board_2 |> GameState.move(:left)
    assert state.score == 4
  end
end
