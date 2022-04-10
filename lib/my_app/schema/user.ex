defmodule MyApp.Schema.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field(:fullname, :string)
    field(:role, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:hashed_password, :string)
    field(:is_verified, :boolean, default: false)
    field(:deactivated, :boolean, default: false)
    
    timestamps(type: :utc_datetime_usec)
  end


  @allowed_fields [
    :fullname,
    :role,
    :email,
    :hashed_password,
    :is_verified,
    :deactivated
  ]


  @required_fields @allowed_fields


  @doc false
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end


  def changeset_with_password(user, params \\ %{}) do
    user
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