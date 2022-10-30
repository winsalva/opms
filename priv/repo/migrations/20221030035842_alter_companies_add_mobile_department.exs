defmodule MyApp.Repo.Migrations.AlterCompaniesAddMobileDepartment do
  use Ecto.Migration

  def change do
    alter table(:companies) do
      add :department, :string
      add :mobile, :string
    end
  end
end
