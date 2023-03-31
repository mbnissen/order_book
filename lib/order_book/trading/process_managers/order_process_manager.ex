defmodule OrderBook.Trading.ProcessManagers.OrderProcessManager do
  alias OrderBook.Trading.Events.OrderRejected
  alias OrderBook.Trading.ProcessManagers.OrderProcessManager
  alias OrderBook.Trading.Commands.{DebitAccount, RejectOrder}
  alias OrderBook.Trading.Events.{AccountDebited, OrderPlaced}

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
  def interested?(%AccountDebited{reference_id: order_id}), do: {:stop, order_id}
  def interested?(%OrderRejected{order_id: order_id}), do: {:stop, order_id}
  def interested?(_event), do: false

  # Command dispatch

  # TODO use order_id
  def handle(%OrderProcessManager{}, %OrderPlaced{} = event) do
    %OrderPlaced{order_id: order_id, account_id: account_id, quantity: quantity, currency: currency} = event

    %DebitAccount{account_id: account_id, amount: quantity, currency: currency, reference_id: order_id}
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

  # Error handlers
  def error(
        {:error, :account_debit_failed},
        _command,
        %{process_manager_state: %{order_id: order_id}} = failure_context
      ) do
    commands = [%RejectOrder{order_id: order_id}]
    {:continue, commands, failure_context}
  end
end
