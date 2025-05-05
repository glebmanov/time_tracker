defmodule TimeTrackerWeb.Timer do
  use TimeTrackerWeb, :live_view

  @tick_interval 1000

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket |> assign(seconds: 0, timer_ref: nil)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col items-center">
      <%= inline_svg("start") %>
      <span class="mb-6">Seconds: {@seconds}</span>
      <button class="mb-3 p-2" disabled={!is_nil(@timer_ref)} phx-click="start">start</button>
      <button class="mb-3 p-2" disabled={is_nil(@timer_ref)} phx-click="stop">stop</button>
    </div>
    """
  end

  @impl true
  def handle_event("start", _params, %{assigns: %{timer_ref: ref}} = socket) do
    if is_reference(ref) do
      {:noreply, socket}
    else
      {:ok, {:interval, ref}} = :timer.send_interval(@tick_interval, self(), :tick)
      {:noreply, assign(socket, timer_ref: ref)}
    end
  end

  @impl true
  def handle_event("stop", _params, %{assigns: %{timer_ref: ref}} = socket) do
    if is_reference(ref) do
      {:ok, :cancel} = :timer.cancel({:interval, ref})
      {:noreply, assign(socket, seconds: 0, timer_ref: nil)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_info(:tick, socket) do
    {:noreply, update(socket, :seconds, &(&1 + 1))}
  end
end
