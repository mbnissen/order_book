defmodule OrderBookWeb.ListTransactionsLive do
  use OrderBookWeb, :live_view

  alias OrderBook.Trading

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    transactions = Trading.list_transactions_for_owner(user_id)

    {:ok, stream(socket, :transactions, transactions)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-slate-700">Transactions</h2>
    <.table id="transactions" rows={@streams.transactions}>
      <:col :let={{_id, transaction}} label="Amount">
        <%= transaction.amount %> <%= transaction.currency %>
      </:col>
      <:col :let={{_id, transaction}} label="Balance before"><%= transaction.balance_before %></:col>
      <:col :let={{_id, transaction}} label="Balance after"><%= transaction.balance_after %></:col>
    </.table>
    """
  end
end
