defmodule MyApp.Repo.Migrations.AlterPrsAddDateNeeded do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :date_needed, :date
    end
  end
end
