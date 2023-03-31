defmodule OrderBook.Trading.Commands.DebitAccount do
  defstruct [:account_id, :amount, :currency, :reference_id]

  use ExConstructor
end
