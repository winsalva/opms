defmodule MyAppWeb.PageController do
  use MyAppWeb, :controller


  def index(conn, _) do
    render(conn, :index)
  end
end