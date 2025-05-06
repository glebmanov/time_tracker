defmodule TimeTrackerWeb.TaskLive.TaskComponent do
  use TimeTrackerWeb, :live_component

  alias TimeTracker.Tracker
  alias TimeTracker.TimeFormatter

  def render(assigns) do
    ~H"""
    <div
      class={"flex items-center mt-3 py-3 px-6 bg-#{@task.color}-100 rounded-md"}
      phx-click="toggle_task"
      phx-value-id={@task.id}
      phx-target={@myself}
    >
      <p style="width: 36px; height: 38px; padding: 6px;">
        <%= if @task.is_active do %>
          <.icon name="hero-stop" />
        <% else %>
          <.icon name="hero-play" />
        <% end %>
      </p>

      <h2 class="mx-6">{@task.name}</h2>

      <div class="flex flex-col mx-3">
        <p class="text-sm text-gray-500">{TimeFormatter.format(0)}</p>
        <p class="text-md text-gray-600">{TimeFormatter.format(@task.total || 0)}</p>
      </div>

      <.link class="ml-auto" style="width: 36px; height: 38px; padding: 6px;" patch={~p"/tasks/#{@task.id}/edit"}>
        <.icon name="hero-pencil" />
      </.link>
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
