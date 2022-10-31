defmodule MyApp.Query.ProcurementRequest do
  @moduledoc """
  Documentation for Procurement Request.
  """

  alias MyApp.Repo
  alias MyApp.Schema.ProcurementRequest, as: PR

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
    Repo.all(PR)
  end

  def get_pr(id) do
    Repo.get(PR, id)
  end
end