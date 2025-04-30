defmodule TimeTrackerWeb.RedirectController do
  use TimeTrackerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/tasks")
  end
end
