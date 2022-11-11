defmodule MyApp.Repo.Migrations.AlterPrsAddUniqueIndex do
  use Ecto.Migration

  def change do
    create unique_index(:prs, [:pr_number])
  end
end
