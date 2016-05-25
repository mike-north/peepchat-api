defmodule Peepchat.RoomView do
  use Peepchat.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]
  has_one :owner, link: :user_link
  has_many :messages, link: :messages_link

  def user_link(room, conn) do
    user_url(conn, :show, room.owner_id)
  end

  def messages_link(room, conn) do
    room_messages_url(conn, :index, room.id)
  end
end
