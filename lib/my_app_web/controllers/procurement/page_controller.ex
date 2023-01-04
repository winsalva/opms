defmodule MyAppWeb.Procurement.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company
  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.PrsRemark, as: Remark

  def failed_prs(conn, _params) do
    prs = PR.list_failed_prs
    end_users = length(Company.list_approved_companies)
    params = [
      prs: prs,
      end_users: end_users
    ]
    render(conn, "failed-prs.html", params)
  end

  def succeeded_prs(conn, _params) do
    prs = PR.list_succeeded_prs
    end_users = length(Company.list_approved_companies)
    params = [
      prs: prs,
      end_users: end_users
    ]
    render(conn, "succeeded-prs.html", params)
  end

  @doc """
  Generate Report.
  """
  def generated_report(conn, _params) do
    failed_prs = PR.list_failed_prs
    completed_prs = PR.list_succeeded_prs
    ongoing_prs = PR.list_ongoing_prs
    end_users = length(Company.list_approved_companies)
    params = [
      failed_prs: failed_prs,
      completed_prs: completed_prs,
      ongoing_prs: ongoing_prs,
      end_users: end_users
    ]
    render(conn, "generated-report.html", params)
  end
  
  def index(conn, %{"id" => id}) do
    prs = Company.get_company_with_procurement_request(id)
    render(conn, :index, prs: prs)
  end

  def search(conn, _params) do
    render(conn, "search.html", query: nil, q_string: "")
  end

  def search_pr(conn, %{"type" => type, "q_string" => q_string}) do
    if conn.assigns.current_company && conn.assigns.current_company.is_admin == true do
      query = PR.admin_search_pr(q_string)
      render(conn, "search.html", query: query, q_string: q_string)
    end

    if conn.assigns.current_company != nil do
      query = PR.user_search_pr(conn.assigns.current_company.id, q_string)
      render(conn, "search.html", query: query, q_string: q_string)
    end
  end
end