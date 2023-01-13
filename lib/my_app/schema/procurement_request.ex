defmodule MyApp.Schema.ProcurementRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "prs" do
    belongs_to :company, MyApp.Schema.Company
    belongs_to :pr_personnel, MyApp.Schema.Company
    has_many :prs_remarks, MyApp.Schema.PrsRemark
    field :pr_number, :integer
    field :status, :string
    field :remarks, :string
    field :purpose, :string
    field :end_user, :string
    field :update_count, :integer, default: 1
    field :seen, :boolean, default: false
    field :bid_mode, :string
    field :date_needed, :date
    field :archive, :boolean, default: false
    timestamps()
  end

  @allowed_fields [
    :company_id,
    :pr_personnel_id,
    :pr_number,
    :status,
    :remarks,
    :end_user,
    :purpose,
    :update_count,
    :seen,
    :bid_mode,
    :date_needed,
    :archive
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