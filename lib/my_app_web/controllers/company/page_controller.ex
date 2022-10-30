defmodule MyAppWeb.Company.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.{Company, Item, Transaction}

  def index(conn, _params) do
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
    company = Company.get_company(id)

    if(company.is_admin) do
      active_transactions = Transaction.list_active_transactions()
      canceled_transactions = Transaction.list_canceled_transactions()
      success_transactions = Transaction.list_success_transactions()
     params = [
       active_transactions: active_transactions,
       canceled_transactions: canceled_transactions,
       success_transactions: success_transactions
     ]
     render(conn, :show, params)
    else
      active_transactions = Transaction.list_company_active_transactions(company.id)
      canceled_transactions = Transaction.list_company_canceled_transactions(company.id)
      success_transactions = Transaction.list_company_success_transactions(company.id)
      params = [
       active_transactions: active_transactions,
       canceled_transactions: canceled_transactions,
       success_transactions: success_transactions
     ]
       render(conn, :show, params)
     end
  end
end