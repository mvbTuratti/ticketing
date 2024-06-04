defmodule Ticketing.GraphqlSchema do
  use Absinthe.Schema

  use AshGraphql, domains: [Ticketing.Support]
  require Ash.Query

  # The query and mutation blocks is where you can add custom absinthe code
  query do
  end

  mutation do
  end

end
