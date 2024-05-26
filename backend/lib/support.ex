defmodule Ticketing.Support do
  use Ash.Domain, extensions: [
    AshGraphql.Domain
  ]

  graphql do
    authorize? false # Defaults to `true`, use this to disable authorization for the entire domain (you probably only want this while prototyping)
  end

  resources do
    resource Ticketing.Support.Ticket
    resource Ticketing.Support.Representative
  end
end
