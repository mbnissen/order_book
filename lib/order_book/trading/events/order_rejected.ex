defmodule OrderBook.Trading.Events.OrderRejected do
  @derive Jason.Encoder
  defstruct [:order_id, :reference_id]
end
