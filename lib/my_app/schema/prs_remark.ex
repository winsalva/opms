defmodule MyApp.Schema.PrsRemark do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prs_remarks" do
    belongs_to :procurement_request, MyApp.Schema.ProcumentRequest
    belongs_to :admin, MyApp.Schema.Company
    field :remarks, :string
    timestamps()
  end


  @allowed_fields [
    :procurement_request_id,
    :admin_id,
    :remarks
  ]
  

  @doc false
  def changeset(prs_remark, params \\ %{}) do
    prs_remark
    |> cast(params, @allowed_fields)
    |> assoc_constraint(:procurement_request)
  end
end