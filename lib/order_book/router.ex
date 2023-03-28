defmodule OrderBook.Router do
  use Commanded.Commands.Router

  alias OrderBook.Accounts.Aggregates.User
  alias OrderBook.Accounts.Commands.RegisterUser

  dispatch(RegisterUser, to: User, identity: :user_id)
end
