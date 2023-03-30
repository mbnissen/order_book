defmodule OrderBook.Trading.Queries.ListOrdersForUser do
  import Ecto.Query

  alias OrderBook.Trading.Projections.Order

  def new(user_id) do
    Order
    |> where([o], o.user_id == ^user_id)
    |> order_by([o], desc: o.placed_at)
  end
end
