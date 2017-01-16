defmodule Peepchat.Room do
  use Peepchat.Web, :model

  schema "rooms" do
    field :name, :string
    belongs_to :owner, Peepchat.Owner

    timestamps()
  end

  @allowed_fields ~w(name)a
  @required_fields @allowed_fields

  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @allowed_fields)
    |> validate_required(@required_fields)
    |> validate_length(:name, min: 4)
    |> unique_constraint(:name)
  end
end
