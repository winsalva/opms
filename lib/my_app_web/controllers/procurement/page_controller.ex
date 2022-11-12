defmodule MyAppWeb.Procurement.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company
  alias MyApp.Query.ProcurementRequest, as: PR
  
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