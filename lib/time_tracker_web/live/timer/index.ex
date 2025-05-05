defmodule TimeTrackerWeb.Timer do
  use TimeTrackerWeb, :live_view

  @tick_interval 1000

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds: 0, timer_ref: nil)}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <span class="mb-6">Seconds: {@seconds}</span>

      <div class="flex">
        <button
          type="button"
          class="mb-3 mr-3 px-4 py-2 flex focus:outline-none text-white bg-green-700 hover:bg-green-800 font-medium rounded-lg text-sm dark:bg-green-600 dark:hover:bg-green-700 dark:focus:ring-green-800"
          disabled={!is_nil(@timer_ref)}
          phx-click="start"
        >
          <span class="mr-2">
            {inline_svg("start")}
          </span>

          <span>
            start
          </span>
        </button>

        <button
          type="button"
          class="mb-3 px-4 py-2 flex text-white bg-gray-800 hover:bg-gray-900 focus:outline-none font-medium rounded-lg text-sm dark:bg-gray-800 dark:hover:bg-gray-700 dark:focus:ring-gray-700 dark:border-gray-700"
          disabled={is_nil(@timer_ref)}
          phx-click="stop"
        >
          <span class="mr-2">
            {inline_svg("stop")}
          </span>

          <span>
            stop
          </span>
        </button>
      </div>
    </div>
    """
  end

  def handle_event("start", _params, %{assigns: %{timer_ref: ref}} = socket) do
    if is_reference(ref) do
      {:noreply, socket}
    else
      {:ok, {:interval, ref}} = :timer.send_interval(@tick_interval, self(), :tick)
      {:noreply, assign(socket, timer_ref: ref)}
    end
  end

  def handle_event("stop", _params, %{assigns: %{timer_ref: ref}} = socket) do
    if is_reference(ref) do
      {:ok, :cancel} = :timer.cancel({:interval, ref})
      {:noreply, assign(socket, seconds: 0, timer_ref: nil)}
    else
      {:noreply, socket}
    end
  end

  def handle_info(:tick, socket) do
    {:noreply, update(socket, :seconds, &(&1 + 1))}
  end
end
