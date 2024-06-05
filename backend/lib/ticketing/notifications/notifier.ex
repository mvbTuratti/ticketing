defmodule Ticketing.Notifications.Notifier do
  use Ash.Notifier
  alias Phoenix.PubSub
  require Ash.Query

  def notify(%Ash.Notifier.Notification{action: %Ash.Resource.Actions.Update{name: :close}, data: data}) do
    PubSub.broadcast(Ticketing.PubSub, "message:updates",
     {:assigned_to_user, %{id: data.id, representative: %{name: data.representative.name, id: data.representative_id}, subject: data.subject, status: data.status}})
    :ok
  end
  def notify(%Ash.Notifier.Notification{action: %Ash.Resource.Actions.Update{name: :assign}, changeset: change, data: data}) do
    %{atomics: [representative_id: representative_id]} = change
    %{id: id} = data
    [ ticket ] = Ticketing.Support.Ticket
      |> Ash.Query.filter(id == ^id)
      |> Ash.read!()
    [ representative ] = Ticketing.Support.Representative
      |> Ash.Query.filter(id == ^representative_id)
      |> Ash.read!()
    PubSub.broadcast(Ticketing.PubSub, "message:updates",
     {:assigned_to_user, %{id: id, representative: %{name: representative.name, id: representative.id}, subject: ticket.subject, status: ticket.status}})
    :ok
  end
  def notify(%Ash.Notifier.Notification{action: %Ash.Resource.Actions.Create{name: :open}, data: data}) do
    IO.puts("CREATE ")
    IO.inspect(data)
    PubSub.broadcast(Ticketing.PubSub, "message:updates",
     {:created, %{id: data.id, name: "", representative: "", subject: data.subject, status: data.status}})
    :ok
  end
  def notify(%Ash.Notifier.Notification{action: %Ash.Resource.Actions.Destroy{name: :destroy}, data: data}) do
    %{id: id} = data
    IO.puts("DELETE")
    IO.inspect(data)
    PubSub.broadcast(Ticketing.PubSub, "message:updates",
     {:deleted, %{id: id}})
    :ok
  end
  def notify(body) do
    IO.puts("default")
    IO.inspect(body)
    :ok
  end
end
