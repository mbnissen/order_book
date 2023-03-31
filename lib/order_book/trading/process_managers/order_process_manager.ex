defmodule OrderBook.Trading.ProcessManagers.OrderProcessManager do
  alias __MODULE__

  alias OrderBook.Trading.ProcessManagers.OrderProcessManager
  alias OrderBook.Trading.Commands.{DebitAccount, RejectOrder}
  alias OrderBook.Trading.Events.{AccountDebited, AccountDebitFailed, OrderPlaced}

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

  def interested?(%OrderPlaced{order_id: order_id}), do: {:start, order_id}

  # {:continue, order_id}
  def interested?(%AccountDebited{reference_id: order_id}), do: {:stop, order_id}

  def interested?(%AccountDebitFailed{reference_id: order_id}), do: {:continue, order_id}

  def interested?(_event), do: false

  # Command dispatch

  # TODO use order_id
  def handle(%OrderProcessManager{}, %OrderPlaced{} = event) do
    %OrderPlaced{order_id: order_id, account_id: account_id, quantity: quantity, currency: currency} = event

    %DebitAccount{account_id: account_id, amount: quantity, currency: currency, reference_id: order_id}
  end

  def handle(%OrderProcessManager{order_id: order_id}, %AccountDebitFailed{}) do
    %RejectOrder{order_id: order_id}
  end

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

  def apply(%OrderProcessManager{} = order, %AccountDebitFailed{}) do
    %OrderProcessManager{order | status: :withdraw_money_from_debit_account_failed}
  end
end
