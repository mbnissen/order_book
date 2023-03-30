defmodule OrderBook.Trading.Queries.ListAccountsForOwner do
  import Ecto.Query

  alias OrderBook.Trading.Projections.Account

  def new(owner_id) do
    from(a in Account,
      where: a.owner_id == ^owner_id
    )
  end
end
