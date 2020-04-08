# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :covid626_front,
  ecto_repos: [Covid626Front.Repo]

# Configures the endpoint
config :covid626_front, Covid626FrontWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UiAzLPczLOd5NYWQJjqZpq2em2fMw25lA1UFMkQSQZ+yvk+hqUFmKcMThE+dg9zc",
  render_errors: [view: Covid626FrontWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Covid626Front.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "KjdRdLtA"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
