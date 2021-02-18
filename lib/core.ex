defmodule Todo.Task.Core do
    alias Todo.Task

    @priorities %{"low" => 0, "medium" => 1, "high" => 2}

    def create(%{title: _title, description: _description, due_date: _due} = params) do
        case all_complete?() do
          true -> Task.create(params)
          false -> {:error, "Cannot create a new task until you finish incomplete tasks!"}
        end
    end

    def get(task), do: Task.get(task)

    def list(), do: Task.get_all()

    def sort_list(tasks, :due_date, order) when order in [:desc, :asc] do
      Enum.sort_by(tasks, &(&1.due_date), {order, Date})
    end

    def sort_list(tasks, :priority, order) when order in [:desc, :asc] do
      Enum.sort_by(tasks, &(sorter(&1.priority)), order)
    end

    def list_by_priority(priority) do
      Task.get_by_priority(priority)
    end

    def list_by_label(label) do
      Task.get_by_label(label)
    end

    def update(task, change_fields) do
      Task.update(task, change_fields)
    end

    def delete(task), do: Task.delete(task)

    def mark_complete(task), do: Task.update(task, %{status: "complete"})

    defp sorter(priority), do: Map.get(@priorities, priority)

    defp all_complete?() do
      Enum.all?(list(), fn task -> task.status == "complete" end)
    end
end
