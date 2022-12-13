defmodule MyApp.Repo.Migrations.AlterCompaniesAddSeen do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :seen, :boolean, default: false
    end
  end
end
