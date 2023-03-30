defmodule OrderBook.Trading.Supervisor do
  use Supervisor

  alias OrderBook.Trading

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    Supervisor.init(
      [
        Trading.Projectors.Account,
        Trading.Projectors.Transaction,
        Trading.Projectors.Order,
        Trading.Workflows.CreateAccountFromUser,
        Trading.Workflows.CreateBTCAccountFromUser
      ],
      strategy: :one_for_one
    )
  end
end
