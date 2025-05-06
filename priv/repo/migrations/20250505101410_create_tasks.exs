defmodule TimeTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :name, :string
      add :color, :string
      add :total, :integer
      add :is_active, :boolean, default: false, null: false
      add :started_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end
  end
end
