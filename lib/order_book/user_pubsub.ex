defmodule OrderBook.UserPubSub do
  alias Phoenix.PubSub

  alias OrderBook.Trading.Projections.{Account, Order, Transaction}

  def subscribe(user_id) do
    PubSub.subscribe(OrderBook.PubSub, "user:#{user_id}")
  end

  def transaction_added(%Transaction{} = transaction) do
    PubSub.broadcast(
      OrderBook.PubSub,
      "user:#{transaction.owner_id}",
      {:transaction_added, %{transaction: transaction}}
    )
  end

  def account_updated(%Account{} = account) do
    PubSub.broadcast(OrderBook.PubSub, "user:#{account.owner_id}", {:account_updated, %{account: account}})
  end

  def order_updated(%Order{} = order) do
    PubSub.broadcast(OrderBook.PubSub, "user:#{order.user_id}", {:order_updated, %{order: order}})
  end
end
