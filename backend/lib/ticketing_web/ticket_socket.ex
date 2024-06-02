defmodule TicketingWeb.TicketSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket,
    schema: Ticketing.Schema
  require Ash.Query

  channel "example", TicketingWeb.TicketSocket
  # def connect(params, socket) do
  #   tickets_assigned_to_user = get_tickets_assigned(params)
  #   socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{
  #     tickets: tickets_assigned_to_user
  #   })
  #   {:ok, socket}
  # end

  # defp get_tickets_assigned(%{"user_id" => user_id}) do
  #   tickets = Ticketing.Support.Ticket
  #   |> Ash.Query.filter(representative_id == ^user_id)
  #   |> Ash.read()
  #   case tickets do
  #     {:ok, ticket} -> ticket
  #     {:error, _} -> []
  #   end
  # end

  # A Socket handler
  #
  # It's possible to control the websocket connection and
  # assign values that can be accessed by your channel topics.

  ## Channels
  # Uncomment the following line to define a "room:*" topic
  # pointing to the `BucketsWeb.RoomChannel`:
  #
  # channel "room:*", BucketsWeb.RoomChannel
  #
  # To create a channel file, use the mix task:
  #
  #     mix phx.gen.channel Room
  #
  # See the [`Channels guide`](https://hexdocs.pm/phoenix/channels.html)
  # for further details.

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error` or `{:error, term}`. To control the
  # response the client receives in that case, [define an error handler in the
  # websocket
  # configuration](https://hexdocs.pm/phoenix/Phoenix.Endpoint.html#socket/3-websocket-configuration).
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  @impl true
  def connect(params, socket, connect_info) do
    IO.inspect(params)
    IO.inspect(socket)
    IO.inspect(connect_info)
    {:ok, socket}
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "user_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     Elixir.BucketsWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  @impl true
  def id(_socket), do: nil

end
