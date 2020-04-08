use Mix.Config

# Configure your database
config :covid626_front, Covid626Front.Repo,
  username: "postgres",
  password: "postgres",
  database: "covid626_front_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :covid626_front, Covid626FrontWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
