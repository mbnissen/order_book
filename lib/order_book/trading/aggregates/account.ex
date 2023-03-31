defmodule OrderBook.Trading.Aggregates.Account do
  defstruct [:id, :owner_id, :balance, :currency]

  alias __MODULE__

  alias OrderBook.Trading.Commands.DebitAccount
  alias OrderBook.Trading.Commands.OpenAccount
  alias OrderBook.Trading.Events.{AccountOpened, AccountDebited}

  def execute(%Account{id: nil}, %OpenAccount{} = command) do
    %AccountOpened{
      account_id: command.account_id,
      owner_id: command.owner_id,
      initial_balance: command.initial_balance,
      currency: command.currency
    }
  end

  def execute(
        %Account{balance: balance, currency: currency},
        %DebitAccount{amount: amount, currency: currency} = command
      ) do
    new_balance = balance - amount

    if new_balance >= 0 do
      %AccountDebited{
        account_id: command.account_id,
        amount: amount,
        currency: command.currency,
        old_balance: balance,
        new_balance: balance - amount,
        reference_id: command.reference_id
      }
    else
      {:error, :account_debit_failed}
    end
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

  def apply(%Account{balance: balance} = account, %AccountDebited{amount: amount}) do
    %Account{account | balance: balance - amount}
  end
end
