defmodule MyApp.Schema.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    has_many :user, MyApp.Schema.User
    belongs_to :item, MyApp.Schema.Item
    belongs_to :buyer_company, MyApp.Schema.Company
    belongs_to :seller_company, MyApp.Schema.Company
    field :buyer_purchase_officer_approval, :boolean, default: false
    field :seller_purchase_officer_approval, :boolean, default: false
    field :buyer_budget_officer_approval, :boolean, default: false
    field :seller_budget_officer_approval, :boolean, default: false
    field :buyer_inventory_officer_approval, :boolean, default: false
    field :seller_inventory_officer_approval, :boolean, default: false

    timestamps()
  end

  @allowed_fields [
    :item_id,
    :buyer_company_id,
    :seller_company_id,
    :buyer_purchase_officer_approval,
    :seller_purchase_officer_approval,
    :buyer_budget_officer_approval,
    :seller_budget_officer_approval,
    :buyer_inventory_officer_approval,
    :seller_inventory_officer_approval
  ]

  @doc false
  def changeset(transaction, params \\ %{}) do
    transaction
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
  end
end