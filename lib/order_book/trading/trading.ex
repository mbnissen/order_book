defmodule OrderBook.Trading do
  alias OrderBook.Repo
  alias OrderBook.App

  alias OrderBook.Trading.Projections.Account

  alias OrderBook.Trading.Commands.{OpenAccount, DebitAccount, PlaceOrder}

  alias OrderBook.Trading.Queries.AccountByCurrency
  alias OrderBook.Trading.Queries.ListTransactionsForOwner
  alias OrderBook.Trading.Queries.ListAccountsForOwner

  def open_account(%{owner_id: owner_id} = attrs) do
    uuid = UUID.uuid4()

    attrs
    |> OpenAccount.new()
    |> OpenAccount.assign_id(uuid)
    |> OpenAccount.assign_owner(owner_id)
    |> OpenAccount.assign_initial_balance()
    |> App.dispatch(consistency: :eventual)
  end

  def debit_account(account_id, %{amount: amount, currency: currency}) do
    DebitAccount.new(account_id: account_id, amount: amount, currency: currency)
    |> App.dispatch(consistency: :eventual)
  end

  def place_order(%Account{} = account, attrs) do
    uuid = UUID.uuid4()

    attrs
    |> PlaceOrder.new()
    |> PlaceOrder.assign_id(uuid)
    |> PlaceOrder.assign_account(account)
    |> App.dispatch(consistency: :eventual)
  end

  def list_account_for_owner(owner_id) do
    ListAccountsForOwner.new(owner_id)
    |> Repo.all()
  end

  def account_by_symbol(user_id, symbol) do
    AccountByCurrency.new(user_id, symbol)
    |> Repo.one!()
  end

  def list_transactions_for_owner(owner_id) do
    ListTransactionsForOwner.new(owner_id)
    |> Repo.all()
  end
end
