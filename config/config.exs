use Mix.Config

config :todo,
  ecto_repos: [Todo.Repo]

config :todo, Todo.Repo,
  database: "postgres",
  username: "postgres",
  hostname: "localhost"

config :logger, level: :warning
