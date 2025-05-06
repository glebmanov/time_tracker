defmodule TimeTrackerWeb.TaskLive.TaskComponent do
  use TimeTrackerWeb, :live_component

  alias TimeTracker.Tracker
  alias TimeTracker.TimeFormatter

  @tick_interval 1000

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div
      class={"flex items-center mt-3 p-3 bg-#{@task.color}-200 "}
      phx-click="toggle_task"
      phx-value-id={@task.id}
      phx-target={@myself}
    >
      <p>{@task.is_active && inline_svg("stop") || inline_svg("start")}</p>

      <h2 class="mx-6">{@task.name}</h2>

      <div class="flex flex-col mx-3">
        <%!-- <p>{TimeFormatter.format(@seconds)}</p> --%>
        <p>{TimeFormatter.format(@task.total)}</p>
      </div>
    </div>
    """
  end

  def handle_event("toggle_task", %{"id" => id}, socket) do
    task = Tracker.get_task!(id)

    updated_task =
      if task.is_active do
        total = task.total || 0
        diff_seconds = DateTime.diff(DateTime.utc_now(), task.started_at)

        {:ok, updated} = Tracker.update_task(task, %{
          is_active: false,
          started_at: nil,
          total: total + diff_seconds
        })

        updated
      else
        {:ok, updated} = Tracker.update_task(task, %{
          is_active: true,
          started_at: DateTime.utc_now()
        })

        updated
      end

    send_update(__MODULE__, id: socket.assigns.id, task: updated_task)

    {:noreply, socket}
  end
end
