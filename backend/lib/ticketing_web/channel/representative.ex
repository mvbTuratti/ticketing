defmodule TicketingWeb.Channel.Representative do
  use Phoenix.Channel
  alias Phoenix.PubSub

  def join("representative:" <> representative_id, params, socket) do
    IO.puts("\n\n")
    IO.puts("JOIN ROOOM")
    IO.inspect(representative_id)
    PubSub.subscribe(Ticketing.PubSub, "message:" <> representative_id)
    {:ok, socket}
  end

  def handle_info({:assigned_to_user, data}, socket) do
    IO.puts("HANDLE INFO")
    IO.inspect(data)
    push(socket, "assigned", data)
    IO.puts("pushed data!")
    {:noreply, socket}
  end
end
