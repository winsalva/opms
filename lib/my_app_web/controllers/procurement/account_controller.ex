defmodule MyAppWeb.Procurement.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.Company
  alias MyApp.Query.PrsRemark, as: Remark

  def ongoing_prs(conn, %{"department" => department, "q_string" => q_string}) do
    prs = PR.list_ongoing_prs
    end_users = length(Company.list_approved_companies)
    if department != "nil" && q_string != "nil" do
      sorted_prs = PR.search_pr(department, q_string)
    
      params = [
        sorted_prs: sorted_prs,
        prs: prs,
        end_users: end_users
      ]
      render(conn, :index, params)
    else
      params = [
        sorted_prs: nil,
        prs: prs,
        end_users: end_users
      ]
      render(conn, :index, params)
    end
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

  def create(conn, %{"procurement_request" => %{"company_id" => company_id, "pr_number" => pr_number, "remarks" => remarks, "status" => status, "altstatus" => altstatus, "bid_mode" => bid_mode, "end_user" => end_user, "purpose" => purpose, "date_needed" => date_needed}}) do
    date =
      if date_needed != "" do
        [y, m, d] = String.split(date_needed, "-")
	{:ok, date_target} = Date.new(String.to_integer(y), String.to_integer(m), String.to_integer(d))
	date_target
      else
        nil
      end

    status =
      if bid_mode == "Alternative" do
        altstatus
      else
        status
      end
      
    params = %{
      company_id: company_id,
      pr_number: pr_number,
      remarks: remarks,
      status: status,
      bid_mode: bid_mode,
      end_user: end_user,
      purpose: purpose,
      pr_personnel_id: conn.assigns.current_company.id,
      date_needed: date,
      archive: false
    }
    
    case PR.insert_pr(params) do
      {:ok, pr} ->

        Remark.insert_prs_remark(%{procurement_request_id: pr.id, admin_id: conn.assigns.current_company.id, status: status, remarks: remarks})
        conn
	|> redirect(to: Routes.pr_account_path(conn, :ongoing_prs, "nil", "nil"))
      {:error, %Ecto.Changeset{} = new_pr} ->
        params = [
	  new_pr: new_pr,
	  departments: Company.list_approved_companies
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
      status: status,
      remarks: remarks,
      update_count: pr.update_count + 1
    }
    
    case PR.update_pr(id, params) do
      {:ok, pr} ->
        Remark.insert_prs_remark(%{"procurement_request_id": id, "admin_id": conn.assigns.current_company.id, "status": status, "remarks": remarks})
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
    |> redirect(to: Routes.pr_account_path(conn, :ongoing_prs, "nil", "nil"))
  end
end