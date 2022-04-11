defmodule MyAppWeb.Company.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company

  def new(conn, _params) do
    company = Company.new_company()
    render(conn, "new.html", company: company)
  end

  def create(conn, %{"company" => company}) do
    conn

  end
end