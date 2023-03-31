defmodule OrderBook.Trading.Aggregates.Order do
  defstruct [:id, :account_id, :type, :quantity, :currency, :price]

  alias __MODULE__
  alias OrderBook.Trading.Commands.{PlaceOrder, RejectOrder}
  alias OrderBook.Trading.Events.{OrderPlaced, OrderRejected}

  def execute(%Order{id: nil}, %PlaceOrder{} = command) do
    %OrderPlaced{
      order_id: command.order_id,
      account_id: command.account_id,
      type: command.type,
      quantity: command.quantity,
      currency: command.currency,
      price: command.price
    }
  end

  def execute(%Order{}, %RejectOrder{order_id: order_id}) do
    %OrderRejected{order_id: order_id}
  end

  def apply(%Order{}, %OrderPlaced{} = event) do
    %Order{
      id: event.order_id,
      account_id: event.account_id,
      type: event.type,
      quantity: event.quantity,
      currency: event.currency,
      price: event.price
    }
  end

  def apply(%Order{} = order, %OrderRejected{}), do: order
end
