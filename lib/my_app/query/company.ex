defmodule MyApp.Query.Company do
  @moduledoc """
  Documentation for Company.
  """

  alias MyApp.Repo
  alias MyApp.Schema.Company

  import Ecto.Query, warn: false

  @doc """
  Get count of newly registered accounts not yet seen by admin.
  """
  def new_registers do
    query =
      from c in Company,
        where: c.seen == false and c.is_admin == false,
	select: c

    Repo.all(query)
    |> length()
  end

  @doc """
  New company
  """
  def new_company do
    %Company{}
    |> Company.changeset_with_password()
  end

  @doc """
  Insert new company.
  """
  def insert_company(params) do
    %Company{}
    |> Company.changeset_with_password(params)
    |> Repo.insert()
  end

  @doc """
  Get company by id.
  """
  def get_company(id) do
    Repo.get(Company, id)
  end

  def delete_company(id) do
    get_company(id)
    |> Repo.delete()
  end

  @doc """
  Get company with procurement requests.
  """
  def get_company_with_procurement_request(id) do
    query =
      from c in Company,
        where: c.id == ^id,
	preload: [procurement_request: [prs_remarks: :admin]]

    Repo.one(query)
  end

  @doc """
  Edit company.
  """
  def edit_company(id) do
    get_company(id)
    |> Company.changeset()
  end

  @doc """
  Update company details.
  """
  def update_company(id, params) do
    get_company(id)
    |> Company.changeset(params)
    |> Repo.update()
  end

  @doc """
  Update all accounts seen to true
  """
  def set_all_accounts_to_true do
    query =
      from c in Company,
        where: c.seen == false

    Repo.all(query)
    |> Enum.each(fn x -> update_company(x.id, %{seen: true}) end)
  end
    

  @doc """
  List all companies.
  """
  def list_companies do
    query =
      from c in Company,
      where: c.is_admin == false,
      order_by: [desc: :inserted_at]
      
    Repo.all(query)
  end

  @doc """
  List all approved companies.
  """
  def list_approved_companies do
    query =
      from c in Company,
        where: c.approved == true and c.is_admin == false,
	order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  List all unapproved companies.
  """
  def list_unapproved_companies do
    query =
      from c in Company,
        where: c.approved == false,
	order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get company by attributes.
  """
  def get_company_by(attr) do
    Repo.get_by(Company, attr)
  end

  @doc """
  Get company account by email and password.
  """
  def get_company_by_email_and_password(email, password) do
    with company when not is_nil(company) <- get_company_by(%{email: String.trim(email)}),
         true <- MyApp.Password.verify_with_hash(password, company.hashed_password),
         true <- company.approved do
      company
    else
      _ -> MyApp.Password.dummy_verify
    end
  end
end