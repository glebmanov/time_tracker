defmodule TimeTracker.TrackerTest do
  use TimeTracker.DataCase

  alias TimeTracker.Tracker

  describe "tasks" do
    alias TimeTracker.Tracker.Task

    import TimeTracker.TrackerFixtures

    @invalid_attrs %{name: nil, total: nil, started_at: nil, color: nil, is_active: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tracker.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tracker.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{name: "some name", total: 42, started_at: ~U[2025-05-04 10:14:00Z], color: "some color", is_active: true}

      assert {:ok, %Task{} = task} = Tracker.create_task(valid_attrs)
      assert task.name == "some name"
      assert task.total == 42
      assert task.started_at == ~U[2025-05-04 10:14:00Z]
      assert task.color == "some color"
      assert task.is_active == true
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tracker.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{name: "some updated name", total: 43, started_at: ~U[2025-05-05 10:14:00Z], color: "some updated color", is_active: false}

      assert {:ok, %Task{} = task} = Tracker.update_task(task, update_attrs)
      assert task.name == "some updated name"
      assert task.total == 43
      assert task.started_at == ~U[2025-05-05 10:14:00Z]
      assert task.color == "some updated color"
      assert task.is_active == false
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tracker.update_task(task, @invalid_attrs)
      assert task == Tracker.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tracker.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tracker.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tracker.change_task(task)
    end
  end
end
