defmodule OrderBook.Trading.Projections.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :balance, :integer
    field :currency, :string
    field :owner_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(trading, attrs) do
    trading
    |> cast(attrs, [:owner_id, :balance, :currency])
    |> validate_required([:owner_id, :balance, :currency])
  end
end
