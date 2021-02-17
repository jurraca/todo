defmodule Todo.Task do
    defstruct [:title, :description, :due_date, :priority, :labels, :status, :is_recurring?]

    def new(fields \\ []) do
      struct!(__MODULE__, fields)
    end
end
