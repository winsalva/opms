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

  def new(conn, _params) do
    item = Item.new_item()
    render(conn, :new, item: item)
  end

  def create(conn, %{"item" => params}) do
    company_id = conn.assigns.current_company.id
    params = Map.put(params, "company_id", company_id)
    case Item.insert_item(params) do
      {:ok, _item} ->
        conn
	|> put_flash(:info, "Posted successfully!\n")
	|> redirect(to: Routes.company_page_path(conn, :show, company_id))
      {:error, %Ecto.Changeset{} = item} ->
        conn
	|> render(:new, item: item)
    end
  end
end