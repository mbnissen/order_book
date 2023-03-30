defmodule OrderBookWeb.PageLive do
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex gap-8">
      <div>
        <%= live_render(@socket, OrderBookWeb.ListAccountsLive,
          id: "list_accounts",
          session: %{"user_id" => @current_user.id}
        ) %>
      </div>
      <div>
        <%= live_render(@socket, OrderBookWeb.ListTransactionsLive,
          id: "list_transactions",
          session: %{"user_id" => @current_user.id}
        ) %>
      </div>
    </div>
    """
  end
end
