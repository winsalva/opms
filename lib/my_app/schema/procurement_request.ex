defmodule MyApp.Schema.ProcurementRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prs" do
    belongs_to :company, MyApp.Schema.Company
    field :pr_personnel_id, :integer
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
  
  @doc false
  def changeset(pr, params \\ %{}) do
    pr
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> assoc_constraint(:company) # must same to belongs_to key
  end
end