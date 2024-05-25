defmodule Ticketing.Support.Ticket do
  # This turns this module into a resource
  use Ash.Resource,
  domain: Ticketing.Support,
  data_layer: AshPostgres.DataLayer,
  # data_layer: Ash.DataLayer.Ets,
  extensions: [
    AshGraphql.Resource
  ]

  postgres do
    table "tickets"
    repo Ticketing.Repo
  end

  actions do
    # Use the default implementation of the :destroy action
    defaults [:read, :destroy]

    create :open do
      accept [:subject]
    end

    read :query_tickets do
      argument :representative_id, :uuid

      pagination offset?: true, countable: :by_default

      filter(
        expr do
          representative_id == ^arg(:representative_id)
        end
      )
    end

    read :check_open do
      filter (
        expr do
          status == :open
        end
      )
    end

    update :close do
      # We don't want to accept any input here
      accept []

      validate attribute_does_not_equal(:status, :closed) do
        message "Ticket is already closed"
      end

      change set_attribute(:status, :closed)
    end
    update :assign do
      accept [:representative_id]
    end

  end
  graphql do
    type :ticket

    queries do
      get :get_ticket, :read
      list :list_tickets, :query_tickets
      list :get_open_ticket, :check_open
    end

    mutations do
      create :create_ticket, :open
      update :assing_representative, :assign
      update :close_ticket, :close
      destroy :delete_ticket, :destroy
    end

  end

  # Attributes are the simple pieces of data that exist on your resource
  attributes do
    # Add an autogenerated UUID primary key called `:id`.
    uuid_primary_key :id

    attribute :subject, :string do
      # Don't allow `nil` values
      allow_nil? false

      # Allow this attribute to be public. By default, all attributes are private.
      public? true
    end
    # status is either `open` or `closed`. We can add more statuses later
    attribute :status, :atom do
      # Constraints allow you to provide extra rules for the value.
      # The available constraints depend on the type
      # See the documentation for each type to know what constraints are available
      # Since atoms are generally only used when we know all of the values
      # it provides a `one_of` constraint, that only allows those values
      constraints [one_of: [:open, :closed]]

      # The status defaulting to open makes sense
      default :open

    end
  end
  relationships do
    # belongs_to means that the destination attribute is unique, meaning only one related record could exist.
    # We assume that the destination attribute is `representative_id` based
    # on the name of this relationship and that the source attribute is `representative_id`.
    # We create `representative_id` automatically.
    belongs_to :representative, Ticketing.Support.Representative do
      public? true
    end
  end


end
