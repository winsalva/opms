defmodule MyAppWeb.User.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.User

  def index(conn, %{"id" => company_id}) do
    purchase = User.get_company_personnel_by_role(company_id, "Purchase")
    budget = User.get_company_personnel_by_role(company_id, "Budget")
    inventory = User.get_company_personnel_by_role(company_id, "Inventory")
    params = [
      purchase: purchase,
      budget: budget,
      inventory: inventory
    ]
    render(conn, :index, params)
  end

  def new_purchaser(conn, _params) do
    user = User.new_user()
    render(conn, "new-purchaser.html", user: user)
  end

  def new_budget_officer(conn, _params) do
    user = User.new_user()
    render(conn, "new-budget-officer.html", user: user)
  end

  def new_inventory_officer(conn, _params) do
    user = User.new_user()
    render(conn, "new-inventory-officer.html", user: user)
  end

  def create_purchaser(conn, %{"user" => params}) do
    company_id = conn.assigns.current_company.id
    params = Map.put(params, "company_id", company_id)
    |> Map.put("role", "Purchase")
    |> Map.put("is_verified", true)
    
    case User.insert_user(params) do
      {:ok, _user} ->
        conn
	|> put_flash(:info, "Purchase Officer account was added successfully.")
	|> redirect(to: Routes.user_account_path(conn, :index, company_id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render("new-purchaser.html", user: user)
    end
  end


  def create_budget_officer(conn, %{"user" => params}) do
    company_id = conn.assigns.current_company.id
    params = Map.put(params, "company_id", company_id)
    |> Map.put("role", "Budget")
    |> Map.put("is_verified", true)

    case User.insert_user(params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Budget Officer account was added successfully.")
        |> redirect(to: Routes.user_account_path(conn, :index, company_id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
        |> render("new-budget-officer.html", user: user)
    end
  end

  def create_inventory_officer(conn, %{"user" => params}) do
    company_id = conn.assigns.current_company.id
    params = Map.put(params, "company_id", company_id)
    |> Map.put("role", "Inventory")
    |> Map.put("is_verified", true)

    case User.insert_user(params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Inventory Officer account was added successfully.")
        |> redirect(to: Routes.user_account_path(conn, :index, company_id))
      {:error, %Ecto.Changeset{} = user} ->
        conn
        |> render("new-inventory-officer.html", user: user)
    end
  end
end