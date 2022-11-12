defmodule MyApp.Repo.Migrations.AlterPrsAddUniqueIndex do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :update_count, :integer
      add :seen, :boolean
    end
    
    create unique_index(:prs, [:pr_number])
  end
end
