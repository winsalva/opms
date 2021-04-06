defmodule MyAppWeb.User.PageController do
  use MyAppWeb, :controller


  alias MyApp.Query.User


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
end