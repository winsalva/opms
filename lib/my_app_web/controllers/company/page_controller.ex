defmodule MyAppWeb.Company.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.{Company, Item, Transaction}

  def index(conn, _params) do
    Company.set_all_accounts_to_true()
    users = Company.list_companies()
    render(conn, :index, users: users)
  end

  def new(conn, _params) do
    company = Company.new_company()
    render(conn, "new.html", company: company)
  end

  def create(conn, %{"company" => company}) do
    case Company.insert_company(company) do
      {:ok, _company} ->
        conn
	|> put_flash(:info, "Your account was created successfully. Please wait for admin approval.")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = company} ->
        conn
	|> render("new.html", company: company)
    end
  end

  def show(conn, %{"id" => id}) do 
    render(conn, :show)
  end

  def delete(conn, %{"id" => id}) do
    case Company.delete_company(id) do
      {:ok, company} ->
        conn
        |> redirect(to: Routes.company_account_path(conn, :notify_account, company.email))
      _error ->
        conn
	|> redirect(to: Routes.company_page_path(conn, :index))
    end
  end
end