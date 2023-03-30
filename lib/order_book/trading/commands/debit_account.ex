defmodule OrderBook.Trading.Commands.DebitAccount do
  defstruct [:account_id, :amount, :currency]

  use ExConstructor
end
