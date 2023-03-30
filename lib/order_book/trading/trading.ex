defmodule OrderBook.Trading do
  alias OrderBook.App
  alias OrderBook.Trading.Commands.OpenAccount

  def open_account(%{owner_id: owner_id} = attrs) do
    uuid = UUID.uuid4()

    attrs
    |> OpenAccount.new()
    |> OpenAccount.assign_id(uuid)
    |> OpenAccount.assign_owner(owner_id)
    |> OpenAccount.assign_initial_balance()
    |> App.dispatch(consistency: :eventual)
  end
end
