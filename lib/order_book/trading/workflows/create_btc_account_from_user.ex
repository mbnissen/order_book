defmodule OrderBook.Trading.Workflows.CreateBTCAccountFromUser do
  use Commanded.Event.Handler,
    application: OrderBook.App,
    name: "OrderBook.Workflows.CreateBTCAccountFromUser",
    consistency: :strong

  alias OrderBook.Accounts.Events.UserRegistered
  alias OrderBook.Trading

  def handle(%UserRegistered{user_id: user_id}, _metadata) do
    :ok = Trading.open_account(%{owner_id: user_id, currency: "BTC"})
  end
end
