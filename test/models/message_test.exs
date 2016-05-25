defmodule Peepchat.MessageTest do
  use Peepchat.ModelCase

  alias Peepchat.Message
  alias Peepchat.Room
  alias Peepchat.User

  test "empty params" do
    changeset = Message.changeset(%Message{}, %{})
    refute changeset.valid?
  end

  test "only body" do
    changeset = Message.changeset(%Message{}, %{body: "some content"})
    refute changeset.valid?
  end

  test "only body and owner" do
    user = %User{}
    changeset = Message.changeset(%Message{user_id: user.id}, %{body: "some content"})
    assert changeset.valid?
  end
end
