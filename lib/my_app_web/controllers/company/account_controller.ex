defmodule MyAppWeb.Company.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company

  def account(conn, %{"id" => id}) do
    company = Company.get_company(id)
    render(conn, "account.html", company: company)
  end

  def edit_account(conn, %{"id" => id}) do
    company = Company.edit_company(id)
    render(conn, "edit-account.html", company: company)
  end


  def update_account(conn, %{"company" => params, "id" => id}) do
    case Company.update_company(id, params) do
      {:ok, _company} ->
        conn
	|> put_flash(:info, "Account updated successfully!")
	|> redirect(to: Routes.company_account_path(conn, :account, id))
      {:error, %Ecto.Changeset{} = company} ->
        conn
	|> render("edit-account.html", company: company)
    end
  end

  def approved_companies(conn, _params) do
    approved_companies = Company.list_approved_companies()
    params = [
      approved_companies: approved_companies
    ]
    render(conn, "approved-companies.html", params)
  end

  def approve_company(conn, %{"id" => id}) do
      params = %{approved: true}
      
      case Company.update_company(id, params) do
      	   {:ok, _company} ->
      	   conn
      	   |> redirect(to: Routes.company_page_path(conn, :index))
    	    _ ->
      	    conn
      	    |> redirect(to: Routes.company_page_path(conn, :index))
      end
  end

  def disapprove_company(conn, %{"id" => id}) do
      params = %{approved: false}
      
      case Company.update_company(id, params) do
           {:ok, company} ->
           conn
           |> redirect(to: Routes.company_account_path(conn, :notify_account, company.email))
            _ ->
            conn
            |> redirect(to: Routes.company_page_path(conn, :index))
      end
  end

  def notify_account(conn, %{"email" => email}) do
    render(conn, "notification-form.html", email: email)
  end

  def unapproved_companies(conn, _params) do
    unapproved_companies = Company.list_unapproved_companies()
    params = [
      unapproved_companies: unapproved_companies
    ]
    render(conn, "unapproved-companies.html", params)
  end
end