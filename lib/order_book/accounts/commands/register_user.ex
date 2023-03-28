defmodule OrderBook.Accounts.Commands.RegisterUser do
  defstruct [:user_id, :email, :password, :hashed_password]

  use ExConstructor

  alias __MODULE__

  @doc """
  Assign a unique identity for the user
  """
  def assign_id(%RegisterUser{} = register_user, id) do
    %RegisterUser{register_user | user_id: id}
  end

  @doc """
  Convert email address to lowercase characters
  """
  def downcase_email(%RegisterUser{email: email} = register_user) do
    %RegisterUser{register_user | email: String.downcase(email)}
  end

  @doc """
  Hash the password, clear the original password
  """
  def hash_password(%RegisterUser{password: password} = register_user) do
    %RegisterUser{register_user | password: nil, hashed_password: Bcrypt.hash_pwd_salt(password)}
  end
end
