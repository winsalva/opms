defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  alias MyApp.Query.User

  def new(conn, _params) do
    if User.list_users == [] do
      User.insert_user(%{
        fullname: "sysadmin",
	role: "sysadmin",
	email: "sysadmin@gmail.com",
	company_id: 1,
	is_verified: true,
	password: "sysadmin",
	password_confirmation: "sysadmin"
	})
	
        render(conn, :new)
    else
      render(conn, :new)
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
    case User.get_user_by_email_and_password(email, password) do
      %MyApp.Schema.User{} = _user ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
      false ->
        conn
	|> put_flash(:error, "Email and Password combination not found!")
	|> redirect(to: Routes.session_path(conn, :new))
    end
  end
end