defmodule MyAppWeb.SessionController do
  use MyAppWeb, :controller

  alias MyApp.Query.{User, Company}

  def new(conn, _params) do
    users = User.list_users
    
    if users == [] do
      company = %{is_admin: true, name: "SysadminCompany", description: "Sysadmin", email: "admin123@gmail.com", password: "admin123", password_confirmation: "admin123", approved: true, mobile: "09091234567", department: "Department"}
      case Company.insert_company(company) do
        {:ok, company} ->
	  User.insert_user(%{
          fullname: "sysadmin",
	  role: "sysadmin",
	  email: "sysadmin@gmail.com",
	  company_id: company.id,
	  is_verified: true,
	  password: "sysadmin",
	  password_confirmation: "sysadmin"
	  })
	  render(conn, :new)
	_error ->
	  render(conn, :new)
      end
    else
      render(conn, :new)
    end
  end

  def create(conn, %{"email" => email, "password" => password}) do
  
    case User.get_user_by_email_and_password(email, password) do
      %MyApp.Schema.User{} = user ->
        conn
	|> put_session(:user_id, user.id)
	|> put_session(:company_id, nil)
	|> configure_session(renew: true)
	|> redirect(to: Routes.user_page_path(conn, :show, user.id))
      false ->
        case Company.get_company_by_email_and_password(email, password) do
	  %MyApp.Schema.Company{} = company ->
	    conn
	    |> put_session(:company_id, company.id)
	    |> put_session(:user_id, nil)
            |> configure_session(renew: true)
	    |> redirect(to: Routes.company_account_path(conn, :account, company.id))
	  _false ->
	    conn
	    |> put_flash(:error, "Email and password combination cannot be found!")
	    |> redirect(to: Routes.session_path(conn, :new))
	end
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
