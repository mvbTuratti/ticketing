defmodule Ticketing.Repo do
  use AshPostgres.Repo, otp_app: :ticketing, adapter: Ecto.Adapters.Postgres
  # use Ecto.Repo,
  #    otp_app: :ticketing,
  #    adapter: Ecto.Adapters.Postgres

  def installed_extensions do
    # Ash installs some functions that it needs to run the
    # first time you generate migrations.
    ["ash-functions"]
  end
end
