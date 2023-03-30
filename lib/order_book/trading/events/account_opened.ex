defmodule OrderBook.Trading.Events.AccountOpened do
  @derive Jason.Encoder
  defstruct [:account_id, :owner_id, :initial_balance, :currency]
end
