defmodule OrderBook.Trading.Commands.OpenAccount do
  defstruct account_id: "", owner_id: "", initial_balance: "", currency: "DKK"

  use ExConstructor

  alias OrderBook.Trading.Commands.OpenAccount

  def assign_id(%OpenAccount{} = command, account_id) do
    %OpenAccount{command | account_id: account_id}
  end

  def assign_owner(%OpenAccount{} = command, owner_id) do
    %OpenAccount{command | owner_id: owner_id}
  end

  def assign_initial_balance(%OpenAccount{currency: "BTC"} = command) do
    %OpenAccount{command | initial_balance: 100}
  end

  def assign_initial_balance(%OpenAccount{} = command) do
    %OpenAccount{command | initial_balance: 10000}
  end
end
