defmodule Todo.Repo.Migrations.CreateTasksTable do
  use Ecto.Migration

  def change do
    create table("tasks") do
      add :title, :string, null: false
      add :description, :string
      add :due_date, :utc_datetime
      add :priority, :string
      add :labels, {:array, :string}
      add :is_recurring?, :boolean
      add :status, :string
      timestamps()
    end

    create unique_index("tasks", [:title])
  end
end
