defmodule OrderBook.Accounts.Projectors.User do
  use Commanded.Projections.Ecto,
    application: OrderBook.App,
    name: "Accounts.Projectors.User",
    repo: OrderBook.Repo,
    consistency: :strong

  alias OrderBook.Accounts.User
  alias OrderBook.Accounts.Events.UserRegistered

  project(%UserRegistered{} = registered, fn multi ->
    Ecto.Multi.insert(multi, :user, %User{
      id: registered.user_id,
      email: registered.email,
      hashed_password: registered.hashed_password
    })
  end)
end
