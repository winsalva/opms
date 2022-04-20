defmodule MyApp.Schema.Negotiation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "negotiations" do
    belongs_to :transaction, MyApp.Schema.Transaction
    belongs_to :user, MyApp.Schema.User
    field :msg, :string
    timestamps()
  end

  @allowed_fields [
    :transaction_id,
    :user_id,
    :msg
  ]

  @doc false
  def changeset(negotiation, params \\ %{}) do
    negotiation
    |> cast(params, @allowed_fields)
    |> validate_required(@allowed_fields)
  end
end