defmodule TicketingWeb.CertApi do
  use TicketingWeb, :controller

  def show(conn, _params) do
    render(conn, "key.json", hello: "world")
  end

  def message(conn, _) do
    render(conn, "message.json", hello: "")
  end

end
