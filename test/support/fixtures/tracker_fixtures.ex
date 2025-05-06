defmodule TimeTracker.TrackerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeTracker.Tracker` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        color: "some color",
        is_active: true,
        name: "some name",
        started_at: ~U[2025-05-04 10:14:00Z],
        total: 42
      })
      |> TimeTracker.Tracker.create_task()

    task
  end
end
