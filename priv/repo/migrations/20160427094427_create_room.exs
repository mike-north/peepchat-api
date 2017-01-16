defmodule Peepchat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :owner_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:rooms, [:owner_id])
    # Unique room names across the whole app
    create index(:rooms, [:name], unique: true)
  end
end
