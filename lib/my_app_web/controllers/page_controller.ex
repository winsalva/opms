defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company
  alias MyApp.Query.ProcurementRequest, as: PR

  def departments(conn, _params) do
    lists = Company.list_companies
    conn
    |> render("departments.html", lists: lists)
  end

  def prs(conn, _params) do
    lists = PR.list_prs
    conn
    |> render("pr.html", lists: lists)
  end

  def test(conn, _params) do
    render(conn, "test.html")
  end

  def index(conn, _) do
    render(conn, :index)
  end

  def about_us(conn, _) do
    render(conn, "about-us.html")
  end

  def contact_us(conn, _) do
    render(conn, "contact-us.html")
  end

  def privacy_policy(conn, _) do
    render(conn, "privacy-policy.html")
  end

  def term_of_use(conn, _) do
    render(conn, "term-of-use.html")
  end

  def under_maintenance(conn, _params) do
    render(conn, "under-maintenance.html")
  end
end