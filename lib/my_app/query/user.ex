defmodule MyApp.Query.User do


  alias MyApp.Schema.User
  alias MyApp.Repo



  def new_user do
    %User{}
    |> User.changeset_with_password()
  end


  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> Repo.insert()
  end


  def get_user(id) do
    Repo.get(User, id)
  end
end