defmodule OrderBookWeb.ListAccountsLive do
  alias OrderBook.Trading
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    accounts = Trading.list_account_for_owner(user_id)

    {:ok, stream(socket, :accounts, accounts)}
  end

  @impl true
  def handle_event(
        "debit_account",
        %{"amount" => amount, "currency" => currency, "id" => account_id},
        socket
      ) do
    Trading.debit_account(account_id, %{amount: String.to_integer(amount), currency: currency})

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-slate-700">Accounts</h2>
    <.table id="accounts" rows={@streams.accounts}>
      <:col :let={{_id, account}} label="Currency"><%= account.currency %></:col>
      <:col :let={{_id, account}} label="Amount">
        <.money amount={account.balance} currency={account.currency} />
      </:col>
      <:col :let={{_id, account}}>
        <.button
          class="text-xs py-1"
          phx-click="debit_account"
          phx-value-amount={100}
          phx-value-currency={account.currency}
          phx-value-id={account.id}
        >
          Debit Account
        </.button>
      </:col>
    </.table>
    """
  end
end
