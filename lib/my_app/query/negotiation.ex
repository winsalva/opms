defmodule MyApp.Query.Negotiation do

  alias MyApp.Repo
  alias MyApp.Schema.Negotiation

  def new_negotiation do
    %Negotiation{}
    |> Negotiation.changeset()
  end

  def insert_negotiation(params) do
    %Negotiation{}
    |> Negotiation.changeset(params)
    |> Repo.insert()
  end

  def list_negotiations do
    Repo.all(Negotiation)
  end
end