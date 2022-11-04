defmodule MyAppWeb.Procurement.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.Company

  def index(conn, _params) do
    prs = PR.list_prs
    end_users = length(Company.list_approved_companies)
    params = [
      prs: prs,
      end_users: end_users
    ]
    render(conn, :index, params)
  end
  
  def new(conn, _params) do
    new_pr = PR.new_pr
    departments = Company.list_companies
    params = [
      new_pr: new_pr,
      departments: departments
    ]
    render(conn, :new, params)
  end

  def create(conn, %{"procurement_request" => params}) do
    params =
      Map.put(params, "pr_personnel_id", conn.assigns.current_company.id)
    
    case PR.insert_pr(params) do
      {:ok, _pr} ->
        conn
	|> redirect(to: Routes.pr_account_path(conn, :index))
      {:error, %Ecto.Changeset{} = new_pr} ->
        params = [
	  new_pr: new_pr,
	  departments: Company.list_companies
	]
        conn
	|> render(:new, params)
    end
  end

  def edit(conn, %{"id" => id}) do
    pr = PR.edit_pr(id)
    departments = Company.list_companies
    params = [
      pr: pr,
      departments: departments
    ]
    render(conn, :edit, params)
  end

  def update(conn, %{"procurement_request" => params, "id" => id}) do
    case PR.update_pr(id, params) do
      {:ok, _pr} ->
        conn
	|> redirect(to: Routes.pr_account_path(conn, :index))
      {:error, %Ecto.Changeset{} = pr} ->
        departments = Company.list_companies
        params = [
          pr: pr,
          departments: departments
        ]
        conn
	|> render(:edit, params)
    end
  end

  def delete(conn, %{"id" => id}) do
    PR.delete_pr(id)
    conn
    |> redirect(to: Routes.pr_account_path(conn, :index))
  end
end