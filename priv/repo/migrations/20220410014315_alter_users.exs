defmodule MyApp.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :role, :string
      add :fullname, :string
      remove :first_name
      remove :middle_name
      remove :last_name
      remove :birth_date
      remove :gender
      remove :about_me
    end

    create unique_index(:users, [:email])
  end
end
