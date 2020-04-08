# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :covid626,
  ecto_repos: [Covid626.Repo]

# Configures the endpoint
config :covid626, Covid626Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "05G06avIy/y64XkNYhP+sy3EcAt5af9Er2SAFde0hEyc5m8mxb9ffNyI8HfIcUCD",
  render_errors: [view: Covid626Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Covid626.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "vxSChz4U"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
