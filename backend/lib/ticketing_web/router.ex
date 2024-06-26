defmodule TicketingWeb.Router do
  use TicketingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    # plug :put_root_layout, html: {TicketingWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug AshGraphql.Plug
  end

  scope "/", TicketingWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/api", TicketingWeb do
    pipe_through :api

    get "/cert", CertApi, :show
    get "/message", CertApi, :message
  end

  scope "/" do
    pipe_through [:graphql]

    forward "/gql",
      Absinthe.Plug,
      schema: Module.concat(["Ticketing.GraphqlSchema"])

    forward "/playground",
            Absinthe.Plug.GraphiQL,
            schema: Module.concat(["Ticketing.GraphqlSchema"]),
            interface: :playground
  end
  # Enable LiveDashboard in development
  if Application.compile_env(:ticketing, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TicketingWeb.Telemetry
    end
  end
end
