defmodule MyApp.Repo.Migrations.AlterCompaniesAddIsAdmin do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :is_admin, :boolean, default: false
    end
  end
end
