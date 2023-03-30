defmodule OrderBook.Trading.Events.OrderPlaced do
  @derive Jason.Encoder

  defstruct [:order_id, :account_id, :type, :quantity, :symbol, :price]
end
