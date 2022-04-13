defmodule MyApp.Repo.Migrations.AlterItemsAddPurpose do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :purpose, :string
      add :company_id, references(:companies, on_delete: :delete_all), null: false
      remove :user_id
    end
  end
end
