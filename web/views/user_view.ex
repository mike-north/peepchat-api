defmodule Peepchat.UserView do
  use Peepchat.Web, :view
  use JaSerializer.PhoenixView
  import Exgravatar

  attributes [:email, :gravatar]
  has_many :rooms, link: :rooms_link
  has_many :messages, link: :messages_link

  def rooms_link(user, conn) do
    user_rooms_url(conn, :index, user.id)
  end

  def messages_link(user, conn) do
    user_messages_url(conn, :index, user.id)
  end

  def gravatar(user, conn) do
    gravatar_url user.email, secure: true, s: 128
  end
end
