defmodule MyApp.Schema.ProcurementRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prs" do
    belongs_to :company, MyApp.Schema.Company
    belongs_to :pr_personnel, MyApp.Schema.Company
    has_many :prs_remarks, MyApp.Schema.PrsRemark
    field :pr_number, :string
    field :status, :string
    field :remarks, :string
    timestamps()
  end

  @allowed_fields [
    :company_id,
    :pr_personnel_id,
    :pr_number,
    :status,
    :remarks
  ]

  @required_fields @allowed_fields
  
  @doc false
  def changeset(pr, params \\ %{}) do
    pr
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> unique_constraint(:pr_number)
    |> assoc_constraint(:company) # must same to belongs_to key
  end
end