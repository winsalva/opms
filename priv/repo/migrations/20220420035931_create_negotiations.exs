defmodule MyApp.Repo.Migrations.CreateNegotiations do
  use Ecto.Migration

  def change do
    create table(:negotiations) do
      add :transaction_id, references(:transactions, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nothing), null: false
      add :msg, :text
      timestamps()
    end
  end
end
