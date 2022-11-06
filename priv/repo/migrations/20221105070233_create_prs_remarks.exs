defmodule MyApp.Repo.Migrations.CreatePrsRemarks do
  use Ecto.Migration

  def change do
    create table(:prs_remarks) do
      add :procurement_request_id, references(:prs, on_delete: :delete_all), null: false
      add :admin_id, references(:companies, on_delete: :nothing)
      add :remarks, :text
      timestamps()
    end
  end
end
