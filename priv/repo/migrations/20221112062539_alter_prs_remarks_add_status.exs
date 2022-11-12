defmodule MyApp.Repo.Migrations.AlterPrsRemarksAddStatus do
  use Ecto.Migration

  def change do
    alter table(:prs_remarks) do
      add :status, :string
    end
  end
end
