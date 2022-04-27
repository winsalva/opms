defmodule MyAppWeb.User.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.{User, Transaction}

  def list_purchase_officers(conn, _params) do
    purchase_officers = User.list_purchase_officers()
    params = [
      purchase_officers: purchase_officers
    ]
    render(conn, "purchase-officers.html", params)
  end

  def list_budget_officers(conn, _params) do
    budget_officers = User.list_budget_officers()
    params = [
      budget_officers: budget_officers
    ]
    render(conn, "budget-officers.html", params)
  end

  def list_inventory_officers(conn, _params) do
    inventory_officers = User.list_inventory_officers()
    params = [
      inventory_officers: inventory_officers
    ]
    render(conn, "inventory-officers.html", params)
  end

  def index(conn, _params) do
    purchase_officers = User.list_purchase_officers()
    budget_officers = User.list_budget_officers()
    inventory_officers = User.list_inventory_officers()
    params = [
      purchase_officers: purchase_officers,
      budget_officers: budget_officers,
      inventory_officers: inventory_officers
    ]
    render(conn, :index, params)
  end

  def new(conn, _params) do
    user = User.new_user()
    render(conn, :new, user: user)
  end

  def create(conn, %{"user" => %{"first_name" => first_name, "middle_name" => middle_name, "last_name" => last_name, "email" => email, "gender" => gender, "birth_date" => birth_date, "about_me" => about_me, "password" => password, "password_confirmation" => password_confirmation} = params}) do
    case User.insert_user(params) do
      {:ok, _user} ->
        conn
	|> put_flash(:info, "New User added")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render(:new, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = User.get_user(id)
    cond do
      user == nil ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
      user.role == "Purchase" ->
        active_transactions = Transaction.list_purchase_officer_active_transactions(user)
	canceled_transactions = Transaction.list_purchase_officer_canceled_transactions(user)
	success_transactions = Transaction.list_purchase_officer_success_transactions(user)
	params = [
	  active_transactions: active_transactions,
	  canceled_transactions: canceled_transactions,
	  success_transactions: success_transactions
	]
        render(conn, :show, params)
      user.role == "Budget" ->
        active_transactions = Transaction.list_budget_officer_active_transactions(user)
        canceled_transactions = Transaction.list_budget_officer_canceled_transactions(user)
        success_transactions = Transaction.list_budget_officer_success_transactions(user)
        params = [
          active_transactions: active_transactions,
          canceled_transactions: canceled_transactions,
          success_transactions: success_transactions
        ]
        render(conn, :show, params)
      user.role == "Inventory" ->
        active_transactions = Transaction.list_inventory_officer_active_transactions(user)
        canceled_transactions = Transaction.list_inventory_officer_canceled_transactions(user)
        success_transactions = Transaction.list_inventory_officer_success_transactions(user)
        params = [
          active_transactions: active_transactions,
          canceled_transactions: canceled_transactions,
          success_transactions: success_transactions
        ]
        render(conn, :show, params)
      true ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
    end
  end
end