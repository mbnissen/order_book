defmodule OrderBookWeb.ListAccountsLive do
  alias OrderBook.Trading
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    accounts = Trading.list_account_for_owner(user_id)

    {:ok, stream(socket, :accounts, accounts)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-slate-700">Accounts</h2>
    <.table id="accounts" rows={@streams.accounts}>
      <:col :let={{_id, account}} label="Currency"><%= account.currency %></:col>
      <:col :let={{_id, account}} label="Amount"><%= account.balance %></:col>
    </.table>
    """
  end
end
