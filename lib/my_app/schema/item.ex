defmodule MyApp.Schema.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    belongs_to :user, MyApp.Schema.User
    field :title, :string
    field :image, :string
    field :description, :string
    field :approved, :boolean, default: false
    timestamps()
  end

  @allowed_fields [
    :user_id,
    :title,
    :image,
    :description,
    :approved
  ]

  @doc false
  def changeset(item, params \\ %{}) do
    item
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
    |> foreign_key_constraint(:user_id)
  end
end