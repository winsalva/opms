defmodule MyApp.Repo.Migrations.AlterCompaniesUniqueDepartment do
  use Ecto.Migration

  def change do
    create unique_index(:companies, [:department])
  end
end
