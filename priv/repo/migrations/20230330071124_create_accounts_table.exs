defmodule OrderBook.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :owner_id, :binary_id
      add :balance, :integer
      add :currency, :string

      timestamps()
    end
  end
end
