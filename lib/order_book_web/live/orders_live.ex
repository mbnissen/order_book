defmodule OrderBookWeb.OrdersLive do
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2 class="text-xl text-slate-700">Orders</h2>
    """
  end
end
