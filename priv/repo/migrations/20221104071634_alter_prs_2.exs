defmodule MyApp.Repo.Migrations.AlterPrs2 do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :pr_personnel_id, references(:companies, on_delete: :nothing)
      remove :pr_personnel
    end
  end
end
