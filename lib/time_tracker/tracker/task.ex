defmodule TimeTracker.Tracker.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    field :total, :integer
    field :started_at, :utc_datetime
    field :color, :string
    field :is_active, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :color, :total, :is_active, :started_at])
    |> validate_required([:name, :color])
  end
end
