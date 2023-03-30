defmodule OrderBook.Trading.Supervisor do
  use Supervisor

  alias OrderBook.Trading

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Trading.Workflows.CreateAccountFromUser
      ],
      strategy: :one_for_one
    )
  end
end
