defmodule OrderBook.Accounts.Aggregates.User do
  defstruct [:id, :email, :hashed_password]

  alias __MODULE__

  alias OrderBook.Accounts.Commands.RegisterUser
  alias OrderBook.Accounts.Events.UserRegistered

  def execute(%User{id: nil}, %RegisterUser{} = command) do
    %UserRegistered{
      user_id: command.user_id,
      email: command.email,
      hashed_password: command.hashed_password
    }
  end

  def apply(%User{} = user, %UserRegistered{} = event) do
    %User{
      user
      | id: event.user_id,
        email: event.email,
        hashed_password: event.hashed_password
    }
  end
end
