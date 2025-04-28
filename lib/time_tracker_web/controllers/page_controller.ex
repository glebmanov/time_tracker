defmodule TimeTrackerWeb.PageController do
  use TimeTrackerWeb, :controller

  def tasks(conn, _params) do
    render(conn, :tasks, tasks: [
      %{:name => "Task 1", :color => "violet", :active => false, :total => 320, :current => 10},
      %{:name => "Task 2", :color => "yellow", :active => false, :total => 150, :current => 15}
    ])
  end

  def settings(conn, _params) do
    render(conn, :settings)
  end
end
