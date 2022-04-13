defmodule MyApp.Schema.Company do
  use Ecto.Schema
  import Ecto.Changeset

  schema "companies" do
    has_many :users, MyApp.Schema.User
    has_many :items, MyApp.Schema.Company
    field :name, :string
    field :description, :string
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :approved, :boolean, default: false
    timestamps()
  end

  @allowed_fields [
    :name,
    :description,
    :email,
    :hashed_password,
    :approved
  ]

  @doc false
  def changeset(company, params \\ %{}) do
    company
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end


  def changeset_with_password(company, params \\ %{}) do
    company
    |> cast(params, [:password])
    |> validate_required(:password)
    |> validate_length(:password, min: 6)
    |> validate_confirmation(:password, required: true)
    |> hash_password()
    |> changeset(params)
  end


  defp hash_password(%Ecto.Changeset{changes: %{password: password}} = changeset) do
    changeset
    |> put_change(:hashed_password, MyApp.Password.hash(password))
  end

  defp hash_password(changeset), do: changeset
end