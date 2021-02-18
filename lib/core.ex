defmodule Todo.Task.Core do
    alias Todo.Schema.Task

    @priorities %{"low" => 0, "medium" => 1, "high" => 2}

    def create(%{title: _title, description: _description, due_date: _due} = params) do
        Task.create(params)
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

    defp sorter(priority) do
      Map.get(@priorities, priority)
    end

    # mark complete
end
