defmodule Peepchat.Router do
  use Peepchat.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
    plug JaSerializer.ContentTypeNegotiation
    plug JaSerializer.Deserializer
  end

  scope "/api", Peepchat do
    pipe_through :api
    # Registration
    post "register", RegistrationController, :create
    # Login
    post "token", SessionController, :create, as: :login
  end

  scope "api", Peepchat do
    pipe_through :api_auth
    get "/user/current", UserController, :current, as: :current_user
    resources "user", UserController, only: [:show, :index] do
      get "rooms", RoomController, :index, as: :rooms
      get "messages", MessageController, :index, as: :messages
    end
    resources "messages", MessageController, only: [:index, :show, :update, :delete, :create]
    resources "rooms", RoomController, except: [:new, :edit] do
      get "messages", MessageController, :index, as: :messages
      post "messages", MessageController, :create, as: :messages
    end
  end
end
