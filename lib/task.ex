defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :due_date, :utc_datetime
    field :priority, :string, default: "low"
    field :labels, {:array, :string}
    field :status, :string, default: "open"
    field :is_recurring?, :boolean, default: false
  end

  def new_changeset(task, params \\ %{}) do
    task
    |> cast(params, [:title, :description, :due_date, :priority, :labels, :status, :is_recurring?])
    |> validate_required([:title, :description, :due_date])
    |> unique_constraint(:title)
  end
end
