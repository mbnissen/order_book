defmodule OrderBook.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :account_id, :binary_id
      add :owner_id, :binary_id
      add :amount, :integer
      add :currency, :string
      add :balance_before, :integer
      add :balance_after, :integer
      add :transaction_time, :utc_datetime_usec

      timestamps()
    end
  end
end
