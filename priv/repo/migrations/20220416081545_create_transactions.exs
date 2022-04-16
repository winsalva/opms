defmodule MyApp.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :item_id, references(:items, on_delete: :nothing), null: false
      add :buyer_company_id, references(:companies, on_delete: :nothing), null: false
      add :seller_company_id, references(:companies, on_delete: :nothing), null: false
      add :buyer_purchase_officer_approval, :boolean, default: false
      add :seller_purchase_officer_approval, :boolean, default: false
      add :buyer_budget_officer_approval, :boolean, default: false
      add :seller_budget_officer_approval, :boolean, default: false
      add :buyer_inventory_officer_approval, :boolean, default: false
      add :seller_inventory_officer_approval, :boolean, default: false
      add :admin_remarks, :string
    end
  end
end
