defmodule MyApp.Query.Item do
  @moduledoc """
  Documentation for Items
  """

  alias MyApp.Repo
  alias MyApp.Schema.Item

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
end