defmodule MyApp.Query.Transaction do

  alias MyApp.Schema.Transaction
  alias MyApp.Repo

  import Ecto.Query, warn: false

  def new_transaction do
    %Transaction{}
    |> Transaction.changeset()
  end

  def insert_transaction(params) do
    %Transaction{}
    |> Transaction.changeset(params)
    |> Repo.insert()
  end

  def list_transactions do
    query =
      from t in Transaction,
        preload: [:item, :negotiation]

    Repo.all(query)
  end

  @doc """
  List all active transactions.
  """
  def list_active_transactions do
    query =
      from t in Transaction,
        where: t.status == "active"

    Repo.all(query)
  end

  @doc """
  List all canceled transactions.
  """
  def list_canceled_transactions do
    query =
      from t in Transaction,
        where: t.status == "canceled"

    Repo.all(query)
  end

  @doc """
  List all success transactions.
  """
  def list_success_transactions do
    query =
      from t in Transaction,
        where: t.status == "success"

    Repo.all(query)
  end

  @doc """
  List all company active transactions.
  """
  def list_company_active_transactions(company_id) do
    query =
      from t in Transaction,
        where: t.status == "active" and (t.buyer_company_id == ^company_id or t.seller_company_id == ^company_id),
	order_by: [desc: :updated_at]

    Repo.all(query)
  end

  @doc """
  List all company canceled transactions.
  """
  def list_company_canceled_transactions(company_id) do
    query =
      from t in Transaction,
        where: t.status == "canceled" and (t.buyer_company_id == ^company_id or t.seller_company_id == ^company_id),
        order_by: [desc: :updated_at]

    Repo.all(query)
  end

  @doc """
  List all company success transactions.
  """
  def list_company_success_transactions(company_id) do
    query =
      from t in Transaction,
        where: t.status == "success" and (t.buyer_company_id == ^company_id or t.seller_company_id == ^company_id),
        order_by: [desc: :updated_at]

    Repo.all(query)
  end
end