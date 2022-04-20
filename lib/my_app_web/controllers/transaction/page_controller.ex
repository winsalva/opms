defmodule MyAppWeb.Transaction.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.{
    Transaction,
    Item,
    Negotiation
  }

  def new_transaction(conn, %{"item_id" => id}) do
    negotiation = Negotiation.new_negotiation()  
    item = Item.get_item(id)
    params = [
      negotiation: negotiation,
      item: item
    ]
    render(conn, "new-transaction.html", params)
  end

  def create_transaction(conn, %{"negotiation" => %{"msg" => msg}, "item_id" => item_id}) do
    item = Item.get_item(item_id)
    transaction_params = %{
      item_id: item.id,
      seller_company_id: item.company_id,
      buyer_company_id: conn.assigns.current_user.company_id
    }
    case Transaction.insert_transaction(transaction_params) do
      {:ok, transaction} ->
        case Negotiation.insert_negotiation(%{msg: msg, transaction_id: transaction.id, user_id_id: conn.assigns.current_user.id}) do
	  {:ok, _negotiation} ->
	    conn
	    |> redirect(to: Routes.user_page_path(conn, :show, conn.assigns.current_user.id))
	    _ -> conn
      	    |> redirect(to: Routes.user_page_path(conn, :show, conn.assigns.current_user.id))
	end
     _ ->
       conn
       |> redirect(to: Routes.user_page_path(conn, :show, conn.assigns.current_user.id))
    end
  end
end