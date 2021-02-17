defmodule Todo.Task do
    alias Todo.Schema.Task

    def create(%{title: title, description: description, due_date: due} = params) do
        Task.create(params)
    end

    def get(task), do: Task.get(task)

    def list(), do: Task.get_all()

    def sort_list(tasks, col, :asc) when is_atom(col) do
      Enum.sort_by(tasks, col, &>=/2)
    end

    def sort_list(tasks, col, :desc) when col in [:priority, :due_date] do
      Enum.sort_by(tasks, col, &<=/2)
    end

    def list_by_priority(priority) do
       Task.get_by_priority(priority)
    end

    def list_by_label(label) do
      Task.get_by_label(label)
    end

    # view a task
    # update
    # delete
    # mark complete
end
