defmodule MyApp.Repo.Migrations.CreatePrs do
  use Ecto.Migration

  ## PRS is short for procurement requests
  def change do
    create table(:prs) do
      add :company_id, references(:companies, on_delete: :delete_all), null: false
      add :pr_personnel_id, :integer
      add :pr_number, :string
      add :status, :string
      add :remarks, :text
      timestamps()
    end
  end
end
