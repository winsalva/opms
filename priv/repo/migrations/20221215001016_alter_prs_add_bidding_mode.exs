defmodule MyApp.Repo.Migrations.AlterPrsAddBiddingMode do
  use Ecto.Migration

  def change do
    alter table(:prs) do
      add :bid_mode, :string
    end
  end
end
