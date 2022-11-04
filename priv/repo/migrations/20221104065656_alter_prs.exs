defmodule MyApp.Repo.Migrations.AlterPrs do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :pr_personnel, references(:companies, on_delete: :nothing)
      remove :pr_personnel_id
    end
  end
end
