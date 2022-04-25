defmodule MyApp.Query.User do
  alias MyApp.Schema.User
  alias MyApp.Repo

  import Ecto.Query, warn: false

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
  List all purchase officers.
  """
  def list_purchase_officers do
    query =
      from u in User,
        where: u.role == "Purchase",
	preload: [:company]

    Repo.all(query)
  end

  @doc """
  List all budget officers.
  """
  def list_budget_officers do
    query =
      from u in User,
        where: u.role == "Budget",
	preload: [:company]

    Repo.all(query)
  end

  @doc """
  List all inventory officers.
  """
  def list_inventory_officers do
    query =
      from u in User,
        where: u.role == "Inventory",
	preload: [:company]

    Repo.all(query)
  end

  @doc """
  List all users/personnels under company.
  """
  def list_company_personnels(company_id) do
    query =
      from u in User,
        where: u.company_id == ^company_id

    Repo.all(query)
  end

  @doc """
  Get company personnel by role.
  """
  def get_company_personnel_by_role(company_id, role) do
    query =
      from u in User,
        where: u.company_id == ^company_id and u.role == ^role

    Repo.one(query)
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
         true <- user.is_verified do
      user
    else
      _ -> MyApp.Password.dummy_verify
    end
  end
end