defmodule Two48.Game do
  use GenServer
  alias Two48.GameState

  def start_link(state \\ initial_state) do
    GenServer.start_link(__MODULE__, state)
  end

  def state(game) do
    GenServer.call(game, :state)
  end

  def move(game, direction) do
    GenServer.call(game, {:move, direction})
  end

  def init(args) do
    {:ok, args}
  end

  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:move, direction}, _from, state) do
    if GameState.can_move?(state, direction) do
      new_state = GameState.move(state, direction)
                  |> GameState.place_random_number
      {:reply, {:ok, new_state}, new_state}
    else
      {:reply, {:error, :illegal_move}, state}
    end
  end

  defp initial_state do
    GameState.new
    |> GameState.place_random_number
    |> GameState.place_random_number
  end
end

