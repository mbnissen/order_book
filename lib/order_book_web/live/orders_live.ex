defmodule OrderBookWeb.OrdersLive do
  alias OrderBook.Trading
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok, assign(socket, :user_id, user_id)}
  end

  @impl true
  def handle_event("place_order", params, socket) do
    :ok =
      Trading.account_by_symbol(socket.assigns.user_id, "BTC")
      |> Trading.place_order(params)

    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-slate-700">Orders</h2>
    <div>
      <.simple_form for={:order} id="order_form" phx-submit="place_order">
        <.input type="select" name="type" label="Type" options={~w"buy bell"} value={} />
        <.input type="number" name="quantity" label="Quantity (BTC)" id="amount" value={1} />
        <.input type="number" name="price" label="Price" id="amount" value={1000} />
        <:actions>
          <.button class="w-full" phx-disable-with="Placing">Place Order</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
