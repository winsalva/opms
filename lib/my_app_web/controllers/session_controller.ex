defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  alias MyApp.Query.User

  def new(conn, _params) do
    render(conn, :new)
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case User.get_user_by_email_and_password(email, password) do
      %MyApp.Schema.User{} = user ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
      false ->
        conn
	|> put_flash(:error, "Email and Password combination not found!")
	|> redirect(to: Routes.session_path(conn, :new))
    end
  end
end