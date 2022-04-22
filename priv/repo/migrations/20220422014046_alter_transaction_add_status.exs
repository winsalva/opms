defmodule MyApp.Repo.Migrations.AlterTransactionAddStatus do
  use Ecto.Migration

  def change do
    alter table(:transactions) do
      add :status, :string, default: "active"
    end
  end
end
