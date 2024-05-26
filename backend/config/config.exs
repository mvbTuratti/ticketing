# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ticketing,
  ecto_repos: [Ticketing.Repo],
  generators: [timestamp_type: :utc_datetime]

config :ticketing, :ash_domains, [Ticketing.Support]

# Configures the endpoint
config :ticketing, TicketingWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: TicketingWeb.ErrorHTML, json: TicketingWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Ticketing.PubSub,
  live_view: [signing_salt: "1Y92pIhN"]

# AshGraphql
# https://hexdocs.pm/ash_graphql/getting-started-with-graphql.html#add-some-backwards-compatibility-configuration
config :ash_graphql, :default_managed_relationship_type_name_template, :action_name
# https://hexdocs.pm/ash_graphql/use-json-with-graphql.html
config :ash_graphql, :json_type, :json

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  ticketing: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.0",
  ticketing: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
