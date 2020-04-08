defmodule Covid626Web.PageController do
  use Covid626Web, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
