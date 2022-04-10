defmodule MyApp.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :type, :string
      add :name, :string
      add :description, :text
      add :email, :string
      add :hashed_password, :string
      add :approved, :boolean, default: false
      timestamps()
    end

    create unique_index(:companies, [:email])
  end
end
