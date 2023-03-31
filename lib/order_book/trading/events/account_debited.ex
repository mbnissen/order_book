defmodule OrderBook.Trading.Events.AccountDebited do
  @derive Jason.Encoder

  defstruct [:account_id, :reference_id, :amount, :currency, :old_balance, :new_balance]
end
