defmodule MyApp.Query.Company do
  @moduledoc """
  Documentation for Company.
  """

  alias MyApp.Repo
  alias MyApp.Schema.Company

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

  @doc """
  List all companies.
  """
  def list_companies do
    Repo.all(Company)
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