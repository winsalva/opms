defmodule MyAppWeb.Company.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Company

  def new(conn, _params) do
    company = Company.new_company()
    render(conn, "new.html", company: company)
  end

  def create(conn, %{"company" => company}) do
    case Company.insert_company(company) do
      {:ok, _company} ->
        conn
	|> put_flash(:info, "Your company account was created successfully!")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = company} ->
        conn
	|> render("new.html", company: company)
    end
  end

  def show(conn, %{"id" => id}) do
    company = Company.get_company(id)
    render(conn, :show, company: company)
  end
end