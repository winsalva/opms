defmodule MyAppWeb.Transaction.PageController do
  use MyAppWeb, :controller

  alias MyApp.Query.{
    Transaction,
    Item,
    Negotiation
  }

  def update_transaction(conn, %{"id" => id}) do
    transaction = Transaction.get_transaction(id)
    user = conn.assigns.current_user
    
    cond do
      user != nil && user.role == "Purchase" && user.company_id == transaction.buyer_company_id ->
        Transaction.update_transaction(id, %{buyer_purchase_officer_approval: true})
	conn
	|> redirect(to: Routes.transaction_page_path(conn, :view_transaction, id))
      user != nil && user.role == "Purchase" && user.company_id == transaction.seller_company_id ->
        Transaction.update_transaction(id, %{seller_purchase_officer_approval: true})
	conn
	|> redirect(to: Routes.transaction_page_path(conn, :view_transaction, id))
      true ->
        conn
	|> redirect(to: Routes.transaction_page_path(conn, :view_transaction, id))
    end
  end   

  def view_transaction(conn, %{"id" => id}) do
    transaction = Transaction.get_transaction(id)
    negotiation = Negotiation.new_negotiation()
    params = [
      transaction: transaction,
      negotiation: negotiation
    ]
    render(conn, "view-transaction.html", params)
  end

  def active_transactions(conn, _params) do
    user = conn.assigns.current_user
    company = conn.assigns.current_company
    
    cond do
      user == nil && company != nil && company.is_admin && company.email == "admin123@gmail.com" ->
        active_transactions = Transaction.list_active_transactions
	params = [
	  active_transactions: active_transactions
	]
	render(conn, "active-transactions.html", params)
      user == nil && company != nil ->
        active_transactions = Transaction.list_company_active_transactions(company.id)
	params = [
	  active_transactions: active_transactions
	]
	render(conn, "active-transactions.html", params)
      user.role == "Purchase" ->
        active_transactions = Transaction.list_purchase_officer_active_transactions(user)
	params = [
	  active_transactions: active_transactions
	]
	render(conn, "active-transactions.html", params)
      true ->
        conn
	|> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def new_transaction(conn, %{"item_id" => id}) do
    negotiation = Negotiation.new_negotiation()  
    item = Item.get_item(id)
    transaction_params = %{
      item_id: item.id,
      seller_company_id: item.company_id,
      buyer_company_id: conn.assigns.current_user.company_id
    }
    {:ok, transaction} = Transaction.insert_transaction(transaction_params)
    params = [
      transaction_id: transaction.id,
      negotiation: negotiation,
      item: item
    ]
    render(conn, "new-transaction.html", params)
  end

  def create_negotiation(conn, %{"negotiation" => %{"msg" => msg}, "user_id" => user_id, "transaction_id" => transaction_id}) do
    params = %{
      msg: msg,
      user_id: user_id,
      transaction_id: transaction_id
    }
    case Negotiation.insert_negotiation(params) do
      {:ok, _negotiation} ->
        conn
	|> redirect(to: Routes.transaction_page_path(conn, :view_transaction, transaction_id))
      {:error, %Ecto.Changeset{} = negotiation} ->
        transaction = Transaction.get_transaction(transaction_id)
	params = [
	  transaction: transaction,
	  negotiation: negotiation
	]
	render(conn, "view-transaction.html", params)
    end
  end

  def create_transaction(conn, %{"negotiation" => %{"msg" => msg}, "item_id" => item_id, "transaction_id" => transaction_id}) do
    item = Item.get_item(item_id)
    case Negotiation.insert_negotiation(%{msg: msg, transaction_id: transaction_id, user_id: conn.assigns.current_user.id}) do
      {:ok, _negotiation} ->
        conn
	|> redirect(to: Routes.user_page_path(conn, :show, conn.assigns.current_user.id))
      {:error, %Ecto.Changeset{} = negotiation} ->
        params = [
	  item: Item.get_item(item_id),
	  negotiation: negotiation,
	  transaction_id: transaction_id
	]
        conn
	|> render("new-transaction.html", params)
    end
  end
end