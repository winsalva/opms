defmodule MyApp.Query.Transaction do

  alias MyApp.Schema.{Transaction, User}
  alias MyApp.Repo

  import Ecto.Query, warn: false


  @doc """
  Update transaction.
  """
  def update_transaction(id, params) do
    get_transaction(id)
    |> Transaction.changeset(params)
    |> Repo.update()
  end

  @doc """
  Get all active transactions for purchase officers.
  """
  def list_purchase_officer_active_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "active" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == false or t.buyer_purchase_officer_approval == false),
	preload: [:item, :buyer_company, :seller_company],
	order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all active transactions for budget officers.
  """
  def list_budget_officer_active_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "active" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == false or t.buyer_budget_officer_approval == false),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all active transactions for inventory officers.
  """
  def list_inventory_officer_active_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "active" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == true and t.buyer_budget_officer_approval == true) and (t.seller_inventory_officer_approval == false or t.buyer_inventory_officer_approval == false),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  List all canceled transactions for purchase officers.
  """
  def list_purchase_officer_canceled_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "canceled" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == false or t.buyer_purchase_officer_approval == false),
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all canceled transactions for budget officers.
  """
  def list_budget_officer_canceled_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "canceled" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == false or t.buyer_budget_officer_approval == false),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all canceled transactions for inventory officers.
  """
  def list_inventory_officer_canceled_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "canceled" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == true and t.buyer_budget_officer_approval == true) and (t.seller_inventory_officer_approval == false or t.buyer_inventory_officer_approval == false),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  List all success transactions for purchase officers.
  """
  def list_purchase_officer_success_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "success" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true or t.buyer_purchase_officer_approval == true),
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all sucess transactions for budget officers.
  """
  def list_budget_officer_success_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "success" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == true or t.buyer_budget_officer_approval == true),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Get all success transactions for inventory officers.
  """
  def list_inventory_officer_success_transactions(user) do
    query =
      from t in Transaction,
        where: t.status == "success" and (t.buyer_company_id == ^user.company_id or t.seller_company_id == ^user.company_id) and (t.seller_purchase_officer_approval == true and t.buyer_purchase_officer_approval == true) and (t.seller_budget_officer_approval == true and t.buyer_budget_officer_approval == true) and (t.seller_inventory_officer_approval == true or t.buyer_inventory_officer_approval == true),
        preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

    Repo.all(query)
  end

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
  Get transaction by id.
  """
  def get_transaction(id) do
    query =
      from t in Transaction,
        where: t.id == ^id,
	preload: [:item, negotiation: :user]

    Repo.one(query)
  end

  @doc """
  List all active transactions.
  """
  def list_active_transactions do
    query =
      from t in Transaction,
        where: t.status == "active",
	preload: [:item, :buyer_company, :seller_company],
	order_by: [desc: :inserted_at]

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
	preload: [:item, :buyer_company, :seller_company],
        order_by: [desc: :inserted_at]

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