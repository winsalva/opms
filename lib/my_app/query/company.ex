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
end