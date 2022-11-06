defmodule MyApp.Query.PrsRemark do

  alias MyApp.Repo
  alias MyApp.Schema.PrsRemark, as: Remark


  def new_prs_remark do
    %Remark{}
    |> Remark.changeset()
  end

  def insert_prs_remark(params) do
    %Remark{}
    |> Remark.changeset(params)
    |> Repo.insert()
  end
end