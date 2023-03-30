defmodule OrderBook.Trading.Queries.ListTransactionsForOwner do
  import Ecto.Query

  alias OrderBook.Trading.Projections.Transaction

  def new(owner_id) do
    Transaction
    |> where([t], t.owner_id == ^owner_id)
    |> order_by([t], desc: t.transaction_time)
  end
end
