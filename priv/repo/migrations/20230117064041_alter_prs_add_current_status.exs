defmodule MyApp.Repo.Migrations.AlterPrsAddCurrentStatus do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :current_status, :string, default: "Ongoing PR"
    end
  end
end
