defmodule MyApp.Repo.Migrations.AlterUsersAddCompanyId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :company_id, references(:companies, on_delete: :delete_all), null: false
    end
  end
end
