defmodule MyAppWeb.Item.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Item

  def index(conn, _params) do
    buys = Item.list_posted_items_for_buying()
    sells = Item.list_posted_items_for_selling()
    params = [
      buys: buys,
      sells: sells
    ]
    render(conn, :index, params)
  end
end