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
  
  def index(conn, %{"id" => id}) do
    prs = Company.get_company_with_procurement_request(id)
    render(conn, :index, prs: prs)
  end

  def search(conn, _params) do
    render(conn, "search.html", query: nil, q_string: "")
  end

  def search_pr(conn, %{"pr_number" => pr_number}) do
    if conn.assigns.current_company && conn.assigns.current_company.is_admin == true do
      query = PR.admin_search_pr(pr_number)
      render(conn, "search.html", query: query, q_string: pr_number)
    end

    if conn.assigns.current_company != nil do
      query = PR.user_search_pr(conn.assigns.current_company.id, pr_number)
      render(conn, "search.html", query: query, q_string: pr_number)
    end
  end
end