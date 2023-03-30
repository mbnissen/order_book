defmodule OrderBook.Trading.Aggregates.Account do
  defstruct [:id, :owner_id, :balance, :currency]

  alias __MODULE__

  alias OrderBook.Trading.Commands.OpenAccount
  alias OrderBook.Trading.Events.AccountOpened

  def execute(%Account{id: nil}, %OpenAccount{} = command) do
    %AccountOpened{
      account_id: command.account_id,
      owner_id: command.owner_id,
      initial_balance: command.initial_balance,
      currency: command.currency
    }
  end

  def apply(%Account{} = account, %AccountOpened{} = event) do
    %Account{
      account
      | id: event.account_id,
        owner_id: event.owner_id,
        balance: event.initial_balance,
        currency: event.currency
    }
  end
end
