defmodule MyAppWeb.User.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.User

  def index(conn, _params) do
    purchase_officers = User.list_purchase_officers()
    budget_officers = User.list_budget_officers()
    inventory_officers = User.list_inventory_officers()
    params = [
      purchase_officers: purchase_officers,
      budget_officers: budget_officers,
      inventory_officers: inventory_officers
    ]
    render(conn, :index, params)
  end

  def new(conn, _params) do
    user = User.new_user()
    render(conn, :new, user: user)
  end

  def create(conn, %{"user" => %{"first_name" => first_name, "middle_name" => middle_name, "last_name" => last_name, "email" => email, "gender" => gender, "birth_date" => birth_date, "about_me" => about_me, "password" => password, "password_confirmation" => password_confirmation} = params}) do
    case User.insert_user(params) do
      {:ok, _user} ->
        conn
	|> put_flash(:info, "New User added")
	|> redirect(to: Routes.page_path(conn, :index))
      {:error, %Ecto.Changeset{} = user} ->
        conn
	|> render(:new, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    case User.get_user(id) do
      nil ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
      user ->
        conn
	|> render(:show, user: user)
    end
  end
end