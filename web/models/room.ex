defmodule Peepchat.Room do
  use Peepchat.Web, :model

  schema "rooms" do
    field :name, :string
    belongs_to :owner, Peepchat.Owner
    has_many :messages, Peepchat.Message
    timestamps
  end

  @required_fields ~w(name owner_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:name, min: 4)
    |> unique_constraint(:name)
    |> assoc_constraint(:owner)
  end
end
