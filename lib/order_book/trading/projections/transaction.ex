defmodule OrderBook.Trading.Projections.Transaction do
  use Ecto.Schema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "transactions" do
    field :account_id, :binary_id
    field :owner_id, :binary_id
    field :amount, :integer
    field :currency, :string
    field :balance_before, :integer
    field :balance_after, :integer
    field :transaction_time, :utc_datetime_usec

    timestamps()
  end
end
