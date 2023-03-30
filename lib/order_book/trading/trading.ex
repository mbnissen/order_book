defmodule OrderBook.Trading do
  alias OrderBook.Trading.Queries.ListAccountsForOwner
  alias OrderBook.App
  alias OrderBook.Trading.Commands.OpenAccount

  alias OrderBook.Repo

  def open_account(%{owner_id: owner_id} = attrs) do
    uuid = UUID.uuid4()

    attrs
    |> OpenAccount.new()
    |> OpenAccount.assign_id(uuid)
    |> OpenAccount.assign_owner(owner_id)
    |> OpenAccount.assign_initial_balance()
    |> App.dispatch(consistency: :eventual)
  end

  def list_account_for_owner(owner_id) do
    ListAccountsForOwner.new(owner_id)
    |> Repo.all()
  end
end
