defmodule MyApp.Repo.Migrations.AlterPrsAddPurposeUser do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :purpose, :string
      add :end_user, :string
    end
  end
end
