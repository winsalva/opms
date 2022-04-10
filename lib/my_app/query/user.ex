defmodule MyApp.Query.User do
  alias MyApp.Schema.User
  alias MyApp.Repo

  @doc """
  New User
  """
  def new_user do
    %User{}
    |> User.changeset_with_password()
  end

  @doc """
  Insert new user
  """
  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> Repo.insert()
  end

  @doc """
  Get user by id
  """
  def get_user(id) do
    Repo.get(User, id)
  end

  @doc """
  List users.
  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Get user by attribute.
  """
  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  @doc """
  Get user by email and password.
  """
  def get_user_by_email_and_password(email, password) do
    with user when not is_nil(user) <- get_user_by(%{email: String.trim(email)}),
         true <- MyApp.Password.verify_with_hash(password, user.hashed_password),
         true <- user.approve do
      user
    else
      _ -> MyApp.Password.dummy_verify
    end
  end
end