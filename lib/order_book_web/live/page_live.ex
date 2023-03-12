defmodule OrderBookWeb.PageLive do
  use OrderBookWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    hello
    """
  end
end
