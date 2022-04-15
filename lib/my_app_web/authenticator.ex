defmodule MyAppWeb.Authenticator do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    company =
      get_session(conn, :company_id)
      |> case do
        nil -> nil
        company_id -> MyApp.Query.Company.get_company(company_id)
      end

    user =
      get_session(conn, :user_id)
      |> case do
        nil -> nil
        user_id -> MyApp.Query.User.get_user(user_id)
      end


    cond do
      company != nil and user != nil ->
        conn
        |> assign(:current_company, company)
        |> assign(:current_user, nil)

      company != nil and user == nil ->
        conn
        |> assign(:current_company, company)
        |> assign(:current_user, nil)

      company == nil and user != nil ->
        conn
        |> assign(:current_company, nil)
        |> assign(:current_user, user)

      true ->
        conn
        |> assign(:current_company, nil)
        |> assign(:current_user, nil)
    end
  end
end