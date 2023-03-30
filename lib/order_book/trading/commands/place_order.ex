defmodule OrderBook.Trading.Commands.PlaceOrder do
  defstruct [:order_id, :account_id, :type, :quantity, :symbol, :price]

  use ExConstructor

  alias OrderBook.Trading.Commands.PlaceOrder
  alias OrderBook.Trading.Projections.Account

  def assign_id(%PlaceOrder{} = command, order_id) do
    %PlaceOrder{command | order_id: order_id}
  end

  def assign_account(%PlaceOrder{} = command, %Account{} = account) do
    %PlaceOrder{command | account_id: account.id, symbol: account.currency}
  end
end
