defmodule MyApp.Query.Item do
  @moduledoc """
  Documentation for Items
  """

  alias MyApp.Repo
  alias MyApp.Schema.Item

  import Ecto.Query, warn: false

  @doc """
  New item.
  """
  def new_item do
    %Item{}
    |> Item.changeset()
  end

  @doc """
  Inserts new item.
  """
  def insert_item(params) do
    %Item{}
    |> Item.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Get item by id.
  """
  def get_item(id) do
    Repo.get(Item, id)
  end

  @doc """
  List items.
  """
  def list_items do
    Repo.all(Item)
  end

  @doc """
  List all posted item for buying
  """
  def list_posted_items_for_buying do
    query =
      from i in Item,
        where: i.purpose == "Buy"

    Repo.all(query)
  end

  @doc """
  List all posted items for selling
  """
  def list_posted_items_for_selling do
    query =
      from i in Item,
        where: i.purpose == "Sell"

    Repo.all(query)
  end
end