defmodule MyAppWeb.Procurement.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company
  
  def index(conn, %{"id" => id}) do
    prs = Company.get_company_with_procurement_request(id)
    render(conn, :index, prs: prs)
  end
end