defmodule MyAppWeb.Procurement.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company
  alias MyApp.Query.ProcurementRequest, as: PR
  alias MyApp.Query.PrsRemark, as: Remark

  def failed_prs(conn, _params) do
    prs = PR.list_failed_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies
    params = [
      departments: departments,
      sorted_prs: "",
      prs: prs,
      end_users: end_users
    ]
    render(conn, "failed-prs.html", params)
  end

  def sort_failed_prs(conn, %{"department_id" => department_id, "q_string" => q_string}) do
    prs = PR.list_failed_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies

    if department_id != "" && q_string != "" do
      sorted_prs = PR.sort_failed_department_prs(String.to_integer(department_id), q_string)

      params = [
        departments: departments,
        sorted_prs: sorted_prs,
        prs: prs,
        end_users: end_users
      ]

      render(conn, "failed-prs.html", params)
    else
      params = [
        departments: departments,
        sorted_prs: nil,
        prs: prs,
        end_users: end_users
      ]
      render(conn, "failed-prs.html", params)
    end
  end

  def succeeded_prs(conn, _params) do
    prs = PR.list_succeeded_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies
    params = [
      departments: departments,
      sorted_prs: "",
      prs: prs,
      end_users: end_users
    ]
    render(conn, "succeeded-prs.html", params)
  end

  def sort_succeeded_prs(conn, %{"department_id" => department_id, "q_string" => q_string}) do
    prs = PR.list_succeeded_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies

    if department_id != "" && q_string != "" do
      sorted_prs = PR.sort_completed_department_prs(String.to_integer(department_id), q_string)

      params = [
        departments: departments,
        sorted_prs: sorted_prs,
        prs: prs,
        end_users: end_users
      ]

      render(conn, "succeeded-prs.html", params)
    else
      params = [
        departments: departments,
        sorted_prs: nil,
        prs: prs,
        end_users: end_users
      ]
      render(conn, "succeeded-prs.html", params)
    end
  end

  @doc """
  Controller for archived procurement requests.
  """
  def archived_prs(conn, _params) do
    prs = PR.list_archived_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies
    params = [
      departments: departments,
      sorted_prs: "",
      prs: prs,
      end_users: end_users
    ]
    render(conn, "archived-prs.html", params)
  end

  def sort_archived_prs(conn, %{"department_id" => department_id, "q_string" => q_string}) do
    prs = PR.list_archived_prs
    end_users = length(Company.list_approved_companies)
    departments = Company.list_companies

    if department_id != "" && q_string != "" do
      sorted_prs = PR.sort_archived_department_prs(String.to_integer(department_id), q_string)

      params = [
        departments: departments,
        sorted_prs: sorted_prs,
        prs: prs,
        end_users: end_users
      ]

      render(conn, "archived-prs.html", params)
    else
      params = [
        departments: departments,
        sorted_prs: nil,
        prs: prs,
        end_users: end_users
      ]
      render(conn, "archived-prs.html", params)
    end
  end

  @doc """
  Generate Report.
  """
  def generated_report(conn, _params) do
    archived_prs = PR.list_archived_prs
    failed_prs = PR.list_failed_prs
    completed_prs = PR.list_succeeded_prs
    ongoing_prs = PR.list_ongoing_prs
    end_users = length(Company.list_approved_companies)
    params = [
      archived_prs: archived_prs,
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
    cond do
      conn.assigns.current_company != nil ->
        render(conn, "search.html", query: [], q_string: "", category: "")
      true ->
        conn
        |> redirect(to: Routes.page_path(conn, :index))
        |> halt()
    end
  end

  def search_pr(conn, %{"category" => category, "sort_by" => sort_by, "q_string" => q_string}) do
    cond do
      conn.assigns.current_company != nil && conn.assigns.current_company.is_admin ->
        query = PR.admin_search_pr(category, sort_by, q_string)
        render(conn, "search.html", query: query, q_string: q_string, category: category)

      conn.assigns.current_company != nil ->
        query = PR.user_search_pr(category, sort_by, q_string, conn.assigns.current_company.id)
	
        render(conn, "search.html", query: query, q_string: q_string, category: category)
      true ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
	|> halt()
    end
  end
end