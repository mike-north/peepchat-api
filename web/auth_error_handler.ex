defmodule Peepchat.AuthErrorHandler do
 use Peepchat.Web, :controller

 def unauthenticated(conn, _params) do
  conn
   |> put_status(401)
   |> render(Peepchat.ErrorView, "401.json")
 end

 def unauthorized(conn, _params) do
  conn
   |> put_status(403)
   |> render(Peepchat.ErrorView, "403.json")
 end
end
