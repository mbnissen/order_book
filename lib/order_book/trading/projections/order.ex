defmodule OrderBook.Trading.Projections.Order do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "orders" do
    field :account_id, :binary_id
    field :user_id, :binary_id
    field :currency, :string
    field :placed_at, :utc_datetime_usec
    field :price, :integer
    field :quantity, :integer
    field :state, :string
    field :type, :string

    timestamps()
  end
end
