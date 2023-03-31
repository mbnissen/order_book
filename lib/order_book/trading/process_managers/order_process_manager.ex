defmodule OrderBook.Trading.ProcessManagers.OrderProcessManager do
  alias __MODULE__

  alias OrderBook.Trading.Commands.DebitAccount
  alias OrderBook.Trading.Events.AccountDebited
  alias OrderBook.Trading.Events.OrderPlaced

  use Commanded.ProcessManagers.ProcessManager,
    application: OrderBook.App,
    name: "Trading.ProcessManagers.OrderProcessManager"

  @derive Jason.Encoder
  defstruct [
    :order_id,
    :debit_account,
    :amount,
    :status
  ]

  # Process routing

  def interested?(%OrderPlaced{order_id: order_id}) do
    {:start, order_id}
  end

  def interested?(%AccountDebited{reference_id: order_id}) do
    {:stop, order_id}
    # {:continue, order_id}
  end

  def interested?(_event), do: false

  # Command dispatch

  def handle(%OrderProcessManager{}, %OrderPlaced{} = event) do
    %OrderPlaced{order_id: order_id, account_id: account_id, quantity: quantity, currency: currency} = event

    %DebitAccount{account_id: account_id, amount: quantity, currency: currency, reference_id: order_id}
  end

  # def handle(%TransferMoneyProcessManager{} = pm, %MoneyWithdrawn{}) do
  #  %TransferMoneyProcessManager{transfer_uuid: transfer_uuid, credit_account: credit_account, amount: amount} = pm

  #  %DepositMoney{account_number: credit_account, transfer_uuid: transfer_uuid, amount: amount}
  # end

  # State mutators

  def apply(%OrderProcessManager{} = order, %OrderPlaced{} = event) do
    %OrderProcessManager{
      order
      | order_id: event.order_id,
        debit_account: event.account_id,
        amount: event.quantity,
        status: :withdraw_money_from_debit_account
    }
  end

  # def apply(%TransferMoneyProcessManager{} = transfer, %MoneyWithdrawn{}) do
  #  %TransferMoneyProcessManager{transfer | status: :deposit_money_in_credit_account}
  # end
end
