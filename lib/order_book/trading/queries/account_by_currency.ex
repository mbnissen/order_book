defmodule OrderBook.Trading.Queries.AccountByCurrency do
  import Ecto.Query

  alias OrderBook.Trading.Projections.Account

  def new(user_id, currency) do
    Account
    |> where([a], a.owner_id == ^user_id)
    |> where([a], a.currency == ^currency)
  end
end
