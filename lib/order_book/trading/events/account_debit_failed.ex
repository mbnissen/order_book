defmodule OrderBook.Trading.Events.AccountDebitFailed do
  @derive Jason.Encoder

  defstruct [:account_id, :reference_id]
end
