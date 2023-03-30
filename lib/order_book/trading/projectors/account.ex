defmodule OrderBook.Trading.Projectors.Account do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Account",
    repo: OrderBook.Repo,
    consistency: :eventual

  alias OrderBook.Repo

  alias OrderBook.UserPubSub
  alias OrderBook.Trading.Projections.Account
  alias OrderBook.Trading.Events.{AccountOpened, AccountDebited}

  project(%AccountOpened{} = event, fn multi ->
    Ecto.Multi.insert(multi, :account, %Account{
      id: event.account_id,
      owner_id: event.owner_id,
      balance: event.initial_balance,
      currency: event.currency
    })
  end)

  project(%AccountDebited{account_id: account_id, new_balance: new_balance}, fn multi ->
    multi
    |> Ecto.Multi.run(:account, fn _repo, _changes -> get_account(account_id) end)
    |> Ecto.Multi.update(:updated_account, fn %{account: account} ->
      Ecto.Changeset.change(account, balance: new_balance)
    end)
  end)

  defp get_account(uuid) do
    case Repo.get(Account, uuid) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  @impl true
  def after_update(%AccountDebited{}, _metadata, %{updated_account: account}) do
    UserPubSub.account_updated(account)
  end
end
