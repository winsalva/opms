defmodule MyAppWeb.Company.AccountController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company

  def approved_companies(conn, _params) do
    approved_companies = Company.list_approved_companies()
    params = [
      approved_companies: approved_companies
    ]
    render(conn, "approved-companies.html", params)
  end

  def unapproved_companies(conn, _params) do
    unapproved_companies = Company.list_unapproved_companies()
    params = [
      unapproved_companies: unapproved_companies
    ]
    render(conn, "unapproved-companies.html", params)
  end
end