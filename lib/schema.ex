defmodule Todo.Schema.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  schema "tasks" do
    field :title, :string
    field :description, :string
    field :due_date, :utc_datetime
    field :priority, :string, default: "low"
    field :labels, {:array, :string}
    field :status, :string, default: "open"
    field :is_recurring?, :boolean, default: false
  end

  def create_changeset(task, params \\ %{}) do
    task
    |> cast(params, [:title, :description, :due_date, :priority, :labels, :status, :is_recurring?])
    |> validate_required([:title, :description, :due_date])
    |> unique_constraint(:title)
  end

  def create(params) do
    Task
    |> create_changeset(params)
    |> Todo.Repo.insert()
  end

  def get_all(), do: Repo.all(Task)

  def get(id) when is_integer(id), do: Repo.get_by(Task, id: id)

  def get_by_priority(priority) do
    Task
    |> where([t], t.priority == ^priority)
    |> order_by([t], [desc: t.due_date])
  end

  def get_by_label(label) when is_binary(label), do: get_by_label([label])

  def get_by_label(labels) when is_list(labels) do
    Task
    |> where([t], fragment("? @> ?", t.labels, ^labels))
    |> order_by([t], [desc: t.due_date])
  end
end
