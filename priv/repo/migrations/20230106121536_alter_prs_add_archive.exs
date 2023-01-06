defmodule MyApp.Repo.Migrations.AlterPrsAddArchive do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :archive, :boolean, default: false
    end
  end
end
