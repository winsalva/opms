defmodule MyApp.Query.ProcurementRequest do
  @moduledoc """
  Documentation for Procurement Request.
  """

  alias MyApp.Repo
  alias MyApp.Schema.ProcurementRequest, as: PR
  alias MyApp.Schema.PrsRemark, as: Remark

  import Ecto.Query, warn: false
  
  def new_pr do
    %PR{}
    |> PR.changeset()
  end

  def insert_pr(params) do
    %PR{}
    |> PR.changeset(params)
    |> Repo.insert()
  end

  def get_pr_with_remarks(id) do
    query =
      from p in PR,
        where: p.id == ^id,
	preload: [:company, prs_remarks: :admin]
	
    Repo.one(query)
  end

  @doc """
  Searches any procurement request by id. If admin.
  """
  def admin_search_pr(pr_number) do
    query =
      from p in PR,
        where: p.pr_number == ^pr_number,
	preload: [:company, prs_remarks: :admin]

    Repo.one(query)
  end

  @doc """
  Search procurement request by id but only for procurement request that belongs to a user.
  """
  def user_search_pr(user_id, pr_number) do
    query =
      from p in PR,
        where: p.pr_number == ^pr_number and p.company_id == ^user_id,
	preload: [:company, prs_remarks: :admin]

    Repo.one(query)
  end


  def list_prs do
    query =
      from p in PR,
        preload: [:company, :pr_personnel]

    Repo.all(query)
  end

  def get_pr(id) do
    Repo.get(PR, id)
  end

  def edit_pr(id) do
    get_pr(id)
    |> PR.changeset()
  end

  def update_pr(id, params) do
    get_pr(id)
    |> PR.changeset(params)
    |> Repo.update()
  end

  def delete_pr(id) do
    get_pr(id)
    |> Repo.delete()
  end
end