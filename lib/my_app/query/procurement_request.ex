defmodule MyApp.Query.ProcurementRequest do
  @moduledoc """
  Documentation for Procurement Request.
  """

  alias MyApp.Repo
  alias MyApp.Schema.ProcurementRequest, as: PR

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