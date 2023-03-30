defmodule OrderBook.Trading.Aggregates.Order do
  defstruct [:id, :account_id, :type, :quantity, :symbol, :price]

  alias __MODULE__
  alias OrderBook.Trading.Commands.PlaceOrder
  alias OrderBook.Trading.Events.OrderPlaced

  def execute(%Order{id: nil}, %PlaceOrder{} = command) do
    %OrderPlaced{
      order_id: command.order_id,
      account_id: command.account_id,
      type: command.type,
      quantity: command.quantity,
      symbol: command.symbol,
      price: command.price
    }
  end

  def apply(%Order{}, %OrderPlaced{} = event) do
    %Order{
      id: event.order_id,
      account_id: event.account_id,
      type: event.type,
      quantity: event.quantity,
      symbol: event.symbol,
      price: event.price
    }
  end
end