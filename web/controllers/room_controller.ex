defmodule Peepchat.RoomController do
  use Peepchat.Web, :controller
  import Ecto.Query

  alias Peepchat.Room

  plug Guardian.Plug.EnsureAuthenticated, handler: Peepchat.AuthErrorHandler

  def index(conn, %{"user_id" => user_id}) do
    rooms = Room
    |> where(owner_id: ^user_id)
    |> Repo.all
    
    render(conn, "index.json", data: rooms)
  end

  def index(conn, _params) do
    rooms = Repo.all(Room)
    render(conn, "index.json", data: rooms)
  end

  def create(conn, %{"data" => %{"type" => "rooms", "attributes" => room_params, "relationships" => _}}) do
    # Get the current user
    current_user = Guardian.Plug.current_resource(conn)
    # Build the current user's ID into the changeset
    changeset = Room.changeset(%Room{owner_id: current_user.id}, room_params)

    case Repo.insert(changeset) do
      {:ok, room} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", room_path(conn, :show, room))
        |> render("show.json", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peepchat.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    room = Repo.get!(Room, id)
    render(conn, "show.json", data: room)
  end

  def update(conn, %{"id" => id, "data" => %{"id" => _, "type" => "rooms", "attributes" => room_params}}) do
    current_user = Guardian.Plug.current_resource(conn)

    room = Room
    |> where(owner_id: ^current_user.id, id: ^id)
    |> Repo.one!

    changeset = Room.changeset(room, room_params)

    case Repo.update(changeset) do
      {:ok, room} ->
        render(conn, "show.json", data: room)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Peepchat.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    room = Room
    |> where(owner_id: ^current_user.id, id: ^id)
    |> Repo.one!

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(room)

    send_resp(conn, :no_content, "")
  end
end
