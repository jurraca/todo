defmodule Todo.Task do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias Todo.Repo

  schema "tasks" do
    field(:title, :string)
    field(:description, :string)
    field(:due_date, :utc_datetime)
    field(:priority, :string, default: "low")
    field(:labels, {:array, :string}, default: [])
    field(:status, :string, default: "open")
    field(:is_recurring?, :boolean, default: false)
    field(:inserted_at, :utc_datetime)
    field(:updated_at, :utc_datetime)
  end

  def create_changeset(task, params \\ %{}) do
    task
    |> cast(params, [:title, :description, :due_date, :priority, :labels, :status, :is_recurring?])
    |> validate_required([:title, :description, :due_date])
    |> unique_constraint(:title)
  end

  def update_changeset(task, params) do
    cast(task, params, [
      :title,
      :description,
      :due_date,
      :priority,
      :labels,
      :status,
      :is_recurring?
    ])
  end

  def create(params) do
    %__MODULE__{}
    |> create_changeset(params)
    |> Repo.insert()
  end

  def get_all(), do: Repo.all(__MODULE__)

  def get_by_id(id), do: Repo.get_by(__MODULE__, id: id)

  def get_by_priority(priority) do
    __MODULE__
    |> where([t], t.priority == ^priority)
    |> order_by([t], desc: t.due_date)
    |> Repo.all()
  end

  def get_by_label(label) when is_binary(label), do: get_by_label([label])

  def get_by_label(labels) when is_list(labels) do
    __MODULE__
    |> where([t], fragment("? @> ?", t.labels, ^labels))
    |> order_by([t], desc: t.due_date)
    |> Repo.all()
  end

  def update(task, changes) do
    task = Ecto.Changeset.change(task, changes)

    case Repo.update(task) do
      {:error, changeset} -> {:error, changeset.errors}
      {:ok, _} = success -> success
    end
  end

  def delete(task), do: Repo.delete(task)
end
