defmodule MyAppWeb.Procurement.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.Company
  alias MyApp.Query.PrsRemark, as: Remark

  def index(conn, _params) do
    prs = PR.list_ongoing_prs
    end_users = length(Company.list_approved_companies)
    params = [
      prs: prs,
      end_users: end_users
    ]
    render(conn, :index, params)
  end
  
  def new(conn, _params) do
    new_pr = PR.new_pr
    departments = Company.list_approved_companies
    params = [
      new_pr: new_pr,
      departments: departments
    ]
    render(conn, :new, params)
  end

  def create(conn, %{"procurement_request" => %{"company_id" => company_id, "pr_number" => pr_number, "remarks" => remarks, "status" => status, "altstatus" => altstatus, "bid_mode" => bid_mode}}) do

    status =
      if bid_mode == "Alternative" do
        altstatus
      else
        status
      end
      
    params = %{
      "company_id": company_id,
      "pr_number": pr_number,
      "remarks": remarks,
      "status": status,
      "bid_mode": bid_mode,
      "pr_personnel_id": conn.assigns.current_company.id
    }
    
    case PR.insert_pr(params) do
      {:ok, pr} ->

        Remark.insert_prs_remark(%{"procurement_request_id": pr.id, "admin_id": conn.assigns.current_company.id, "status": status, "remarks": remarks})

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

  def show(conn, %{"id" => id}) do
    if conn.assigns.current_company != nil && conn.assigns.current_company.is_admin == false do
      # Reset update to 0 viewed by end user
      PR.update_pr(id, %{update_count: 0})
    
      pr = PR.get_pr_with_remarks(id)
      render(conn, :show, pr: pr)
    else
      pr = PR.get_pr_with_remarks(id)
      render(conn, :show, pr: pr)
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

  def update(conn, %{"procurement_request" => %{ "remarks" => remarks, "status" => status}, "id" => id}) do
  
    pr = PR.get_pr(id)
    
    params = %{
      "status": status,
      "remarks": remarks,
      "update_count": pr.update_count + 1
    }

    Remark.insert_prs_remark(%{"procurement_request_id": id, "admin_id": conn.assigns.current_company.id, "status": status, "remarks": remarks})
    
    case PR.update_pr(id, params) do
      {:ok, pr} ->
        conn
	|> redirect(to: Routes.pr_account_path(conn, :show, pr.id))
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