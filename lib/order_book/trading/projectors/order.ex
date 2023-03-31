defmodule OrderBook.Trading.Projectors.Order do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Order",
    repo: OrderBook.Repo,
    consistency: :strong

  alias OrderBook.Repo
  alias OrderBook.UserPubSub

  alias OrderBook.Trading.Events.OrderRejected

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
        quantity: event.quantity,
        price: event.price,
        placed_at: placed_at
      }

      Repo.insert(order)
    end)
  end)

  project(%OrderRejected{order_id: order_id}, fn multi ->
    multi
    |> Ecto.Multi.run(:order, fn _repo, _changes -> get_order(order_id) end)
    |> Ecto.Multi.update(:updated_order, fn %{order: order} ->
      Ecto.Changeset.change(order, state: "rejected")
    end)
  end)

  defp get_order(id) do
    case Repo.get(Order, id) do
      nil -> {:error, :order_not_found}
      order -> {:ok, order}
    end
  end

  defp get_account(id) do
    case Repo.get(Account, id) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  @impl true
  def after_update(%OrderRejected{}, _metadata, %{updated_order: order}) do
    UserPubSub.order_updated(order)
  end

  @impl true
  def after_update(_, _, _) do
    :ok
  end
end
