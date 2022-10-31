defmodule MyAppWeb.Procurement.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.Company

  def index(conn, _params) do
    prs = PR.list_prs
    render(conn, :index, prs: prs)
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
    params = Map.put(params, "pr_personnel_id", conn.assigns.current_company.id)
    
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
end