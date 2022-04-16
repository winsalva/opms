defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller

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
end