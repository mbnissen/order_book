defmodule OrderBook.Trading.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Account",
    repo: OrderBook.Repo,
    consistency: :strong

  alias OrderBook.Trading.Projections.Account
  alias OrderBook.Trading.Events.{AccountOpened, AccountDebited}

  project(%AccountOpened{} = event, fn multi ->
    Ecto.Multi.insert(multi, :user, %Account{
      id: event.account_id,
      owner_id: event.owner_id,
      balance: event.initial_balance,
      currency: event.currency
    })
  end)

  project(%AccountDebited{account_id: account_id, new_balance: new_balance}, fn multi ->
    update_account(multi, account_id, balance: new_balance)
  end)

  defp update_account(multi, account_id, changes) do
    Ecto.Multi.update_all(multi, :account, account_query(account_id), set: changes)
  end

  defp account_query(account_id) do
    from(a in Account, where: a.id == ^account_id)
  end
end
