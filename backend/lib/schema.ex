defmodule Ticketing.GraphqlSchema do
  use Absinthe.Schema

  use AshGraphql, domains: [Ticketing.Support]
  require Ash.Query

  # The query and mutation blocks is where you can add custom absinthe code
  query do
  end

  mutation do
  end

  subscription do
    field :assing_representative, :ticket do
      arg :representative_id, :string

      config fn args, _ ->
        {:ok, topic: args.representative_id}
      end

      resolve(fn args, _, resolution ->
        # loads all the data you need
        AshGraphql.Subscription.query_for_subscription(
          Ticketing.Support.Ticket,
          Ticketing.Support,
          resolution
        )
        |> IO.inspect()
        |> Ash.Query.filter(representative_id == ^args.representative_id)
        |> Ash.read()
      end)
    end
  end

end
