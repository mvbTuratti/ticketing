defmodule Ticketing.Notifications.Notifier do
  use Ash.Notifier
  alias Phoenix.PubSub
  require Ash.Query

  def notify(%Ash.Notifier.Notification{action: %Ash.Resource.Actions.Update{name: :assign}, changeset: change, data: data}) do
    %{atomics: [representative_id: representative_id]} = change
    %{id: id} = data
    [ ticket ] = Ticketing.Support.Ticket
      |> Ash.Query.filter(id == ^id)
      |> Ash.read!()
    [ representative ] = Ticketing.Support.Representative
      |> Ash.Query.filter(id == ^representative_id)
      |> Ash.read!()
    PubSub.subscribe(Ticketing.PubSub, "message:" <> representative_id)
    PubSub.broadcast(Ticketing.PubSub, "message:" <> representative_id,
     {:assigned_to_user, %{id: id, name: representative.name, representative_id: representative_id, subject: ticket.subject, status: ticket.status}})
    :ok
  end
  def notify(_), do: :ok
end
