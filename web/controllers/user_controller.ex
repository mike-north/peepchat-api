defmodule Peepchat.UserController do
  use Peepchat.Web, :controller

  alias Peepchat.User
  plug Guardian.Plug.EnsureAuthenticated, handler: Peepchat.AuthErrorHandler

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json-api", data: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json-api", data: user)
  end

  def current(conn, _) do
    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render(Peepchat.UserView, "show.json-api", data: user)
  end
end
