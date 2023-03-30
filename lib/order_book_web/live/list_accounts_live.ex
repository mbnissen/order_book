defmodule OrderBookWeb.ListAccountsLive do
  use OrderBookWeb, :live_view

  alias OrderBook.UserPubSub
  alias OrderBook.Trading

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    if connected?(socket), do: UserPubSub.subscribe(user_id)

    accounts = Trading.list_account_for_owner(user_id)

    {:ok, stream(socket, :accounts, accounts)}
  end

  @impl true
  def handle_event("debit_account", %{"currency" => currency, "id" => account_id}, socket) do
    :ok = debit_account(account_id, currency)

    {:noreply, socket}
  end

  defp debit_account(account_id, "BTC") do
    Trading.debit_account(account_id, %{amount: 1, currency: "BTC"})
  end

  defp debit_account(account_id, currency) do
    Trading.debit_account(account_id, %{amount: 100, currency: currency})
  end

  @impl true
  def handle_info({:account_updated, %{account: account}}, socket) do
    {:noreply, stream_insert(socket, :accounts, account)}
  end

  # Ignore other events
  @impl true
  def handle_info(_, socket), do: {:noreply, socket}

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
