defmodule OrderBook.Router do
  use Commanded.Commands.Router

  alias OrderBook.Accounts.Aggregates.User
  alias OrderBook.Accounts.Commands.RegisterUser

  alias OrderBook.Trading.Aggregates.Account
  alias OrderBook.Trading.Commands.{OpenAccount, DebitAccount}

  dispatch(RegisterUser, to: User, identity: :user_id)

  dispatch(OpenAccount, to: Account, identity: :account_id)
  dispatch(DebitAccount, to: Account, identity: :account_id)
end
