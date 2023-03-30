defmodule OrderBook.Trading.Projectors.Transaction do
  alias OrderBook.UserPubSub
  alias OrderBook.Trading.Projections.Account
  alias OrderBook.Repo
  alias OrderBook.Trading.Events.AccountDebited

  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Trading.Projectors.Transaction",
    repo: OrderBook.Repo,
    consistency: :eventual

  alias OrderBook.Trading.Projections.Transaction

  project(
    %AccountDebited{account_id: account_id} = event,
    %{created_at: transaction_time},
    fn multi ->
      multi
      |> Ecto.Multi.run(:account, fn _repo, _changes -> get_account(account_id) end)
      |> Ecto.Multi.run(:transaction, fn _repo, %{account: account} ->
        transaction = %Transaction{
          account_id: account_id,
          owner_id: account.owner_id,
          amount: event.amount,
          currency: event.currency,
          balance_before: event.old_balance,
          balance_after: event.new_balance,
          transaction_time: transaction_time
        }

        Repo.insert(transaction)
      end)
    end
  )

  defp get_account(uuid) do
    case Repo.get(Account, uuid) do
      nil -> {:error, :account_not_found}
      account -> {:ok, account}
    end
  end

  @impl true
  def after_update(%AccountDebited{}, _metadata, %{transaction: transaction}) do
    UserPubSub.transaction_added(transaction)
  end
end
