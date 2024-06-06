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


config :joken,
  my_rsa_key: [
    signer_alg: "RS256",
    key_pem: """
    -----BEGIN PRIVATE KEY-----
    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
    0NzRX/mWI+9h1FWaHnUkjmrO3sUlqA==
    -----END PRIVATE KEY-----
    """
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
