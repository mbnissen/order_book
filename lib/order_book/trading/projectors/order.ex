defmodule OrderBook.Trading.Projectors.Order do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Order",
    repo: OrderBook.Repo,
    consistency: :strong

  alias OrderBook.Repo

  alias OrderBook.Trading.Projections.Account
  alias OrderBook.Trading.Projections.Order
  alias OrderBook.Trading.Events.OrderPlaced

  project(%OrderPlaced{account_id: account_id} = event, %{created_at: placed_at}, fn multi ->
    multi
    |> Ecto.Multi.run(:account, fn _repo, _changes -> get_account(account_id) end)
    |> Ecto.Multi.run(:order, fn _repo, %{account: account} ->
      order = %Order{
        id: event.order_id,
        account_id: account_id,
        user_id: account.owner_id,
        type: event.type,
        currency: event.currency,
        state: "placed",
        # TODO do this in a different way
        quantity: String.to_integer(event.quantity),
        price: String.to_integer(event.price),
        placed_at: placed_at
      }

      Repo.insert(order)
    end)
  end)

  defp get_account(uuid) do
    case Repo.get(Account, uuid) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end
end
