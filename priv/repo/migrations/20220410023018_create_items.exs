defmodule MyApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :title, :string
      add :image, :string
      add :description, :text
      add :approved, :boolean, default: false
      timestamps()
    end
  end
end
