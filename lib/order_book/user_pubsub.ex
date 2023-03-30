defmodule OrderBook.UserPubSub do
  alias Phoenix.PubSub

  alias OrderBook.Trading.Projections.Transaction

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
end
