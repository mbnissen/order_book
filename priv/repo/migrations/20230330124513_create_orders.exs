defmodule OrderBook.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_id, :binary_id
      add :user_id, :binary_id
      add :type, :string
      add :quantity, :integer
      add :price, :integer
      add :currency, :string
      add :state, :string
      add :placed_at, :utc_datetime_usec

      timestamps()
    end
  end
end
