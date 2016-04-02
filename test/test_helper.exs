ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Peepchat.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Peepchat.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Peepchat.Repo)

