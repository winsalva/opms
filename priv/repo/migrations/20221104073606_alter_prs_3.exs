defmodule MyApp.Repo.Migrations.AlterPrs3 do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      remove :pr_personnel_id
      add :pr_personnel, references(:companies, on_delete: :nothing)
      add :pr_personnel_id, :integer
    end
  end
end
