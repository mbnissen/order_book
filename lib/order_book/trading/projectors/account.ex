defmodule OrderBook.Trading.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Account",
    repo: OrderBook.Repo,
    consistency: :strong

  alias OrderBook.Trading.Projections.Account
  alias OrderBook.Trading.Events.AccountOpened

  project(%AccountOpened{} = event, fn multi ->
    Ecto.Multi.insert(multi, :user, %Account{
      id: event.account_id,
      owner_id: event.owner_id,
      balance: event.initial_balance,
      currency: event.currency
    })
  end)
end
