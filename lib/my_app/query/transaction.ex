defmodule MyApp.Query.Transaction do

  alias MyApp.Schema.Transaction
  alias MyApp.Repo

  def new_transaction do
    %Transaction{}
    |> Transaction.changeset()
  end

  def insert_transaction(params) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end
end