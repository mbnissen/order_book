defmodule OrderBook.Trading.Queries.ListTransactionsForOwner do
  import Ecto.Query

  alias OrderBook.Trading.Projections.Transaction

  def new(owner_id) do
    from(a in Transaction,
      where: a.owner_id == ^owner_id
    )
  end
end
