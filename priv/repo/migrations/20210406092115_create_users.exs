defmodule MyApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :birth_date, :date
      add :gender, :string
      add :about_me, :text
      add :email, :string
      add :hashed_password, :string
      add :is_verified, :boolean, default: false
      add :deactivated, :boolean, default: false
    
      timestamps(type: :utc_datetime_usec)
    end
  end
end
