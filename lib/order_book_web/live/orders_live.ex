defmodule OrderBookWeb.OrdersLive do
  alias OrderBook.Trading
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    {:ok,
     socket
     |> stream(:orders, Trading.list_orders_for_user(user_id))
     |> assign(:user_id, user_id)}
  end

  @impl true
  def handle_event("place_order", params, socket) do
    {:ok, order} =
      Trading.account_by_symbol(socket.assigns.user_id, "BTC")
      |> Trading.place_order(params)
      |> dbg()

    {:noreply, stream_insert(socket, :orders, order, at: 0)}
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
    <.table id="orders" rows={@streams.orders}>
      <:col :let={{_id, order}} label="Quantity">
        <.money amount={order.quantity} currency={order.currency} />
      </:col>
      <:col :let={{_id, order}} label="Price">
        <.money amount={order.price} currency={order.currency} />
      </:col>
      <:col :let={{_id, order}} label="State">
        <span class="bg-green-100 text-green-800 text-xs font-medium px-2.5 py-1 rounded-full dark:bg-green-900 dark:text-green-300">
          <%= order.state %>
        </span>
      </:col>
      <:col :let={{_id, order}} label="Placed">
        <%= Cldr.DateTime.to_string!(order.placed_at, OrderBook.Cldr, format: :short) %>
      </:col>
    </.table>
    """
  end
end
