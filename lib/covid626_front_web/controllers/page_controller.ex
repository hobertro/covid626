defmodule Covid626FrontWeb.PageController do
  use Covid626FrontWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
