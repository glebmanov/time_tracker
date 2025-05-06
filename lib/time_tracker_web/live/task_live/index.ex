defmodule TimeTrackerWeb.TaskLive.Index do
  use TimeTrackerWeb, :live_view

  alias TimeTracker.Tracker
  alias TimeTracker.Tracker.Task

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, tasks: Tracker.list_tasks())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Task")
    |> assign(:task, Tracker.get_task!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
    |> assign(:task, %Task{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Tasks")
    |> assign(:task, nil)
  end

  @impl true
  def handle_info({TimeTrackerWeb.TaskLive.FormComponent, {:saved, task}}, socket) do
    updated_tasks =
      socket.assigns.tasks
      |> Enum.reject(&(&1.id == task.id))
      |> then(&[task | &1])

    {:noreply, assign(socket, tasks: updated_tasks)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    task = Tracker.get_task!(id)
    {:ok, _} = Tracker.delete_task(task)

    updated_tasks =
      socket.assigns.tasks
      |> Enum.reject(&(&1.id == task.id))

    {:noreply, assign(socket, tasks: updated_tasks)}
  end
end
