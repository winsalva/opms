defmodule MyAppWeb.Item.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.Item

  def index(conn, _params) do
    items = Item.list_items()
    render(conn, :index, items: items)
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
	|> redirect(to: Routes.item_page_path(conn, :show, company_id))
      {:error, %Ecto.Changeset{} = item} ->
        conn
	|> render(:new, item: item)
    end
  end

  def show(conn, %{"id" => company_id}) do
    items_to_buy = Item.list_company_posted_items_for_buying(company_id)
    items_to_sell = Item.list_company_posted_items_for_selling(company_id)
    params = [
      items_to_buy: items_to_buy,
      items_to_sell: items_to_sell
    ]
    render(conn, :show, params)
  end

  def items_to_buy(conn, _params) do
    company_id = conn.assigns.current_company.id
    items_to_buy = Item.list_company_posted_items_for_buying(company_id)
    params = [
      items_to_buy: items_to_buy
    ]
    render(conn, "items-to-buy.html", params)
  end

  def items_to_sell(conn, _params) do
    company_id = conn.assigns.current_company.id
    items_to_sell = Item.list_company_posted_items_for_selling(company_id)
    params = [
      items_to_sell: items_to_sell
    ]
    render(conn, "items-to-sell.html", params)
  end
end