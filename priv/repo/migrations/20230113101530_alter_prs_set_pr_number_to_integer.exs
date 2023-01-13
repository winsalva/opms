defmodule MyApp.Repo.Migrations.AlterPrsSetPrNumberToInteger do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      remove :pr_number
      add :pr_number, :integer
    end
  end
end
