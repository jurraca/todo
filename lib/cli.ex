defmodule Todo.CLI do
  @behaviour Ratatouille.App

  import Ratatouille.View
  alias Ratatouille.Constants
  alias Todo.Task.Core
  alias Todo.Task

  # the model will always be a list of Tasks.
  # the user should be able to key up and down through the tasks and select them, in order to modify them.
  def init(_context), do: Core.list()

  def update(model, msg) do
    case msg do
      {:event, %{ch: ?q}} -> Todo.Application.stop(:ok)
      #{:event, %{ch: ?-}} -> model - 1
      _ -> model
    end
  end

  def render(model) do
    view do
      panel title: "Tasks v0.1" do
        panel title: "Your Tasks" do
          table do
            table_row do
              table_cell(content: "Title")
              table_cell(content: "Description")
              table_cell(content: "Status")
              table_cell(content: "Due Date")
            end
            Enum.map(model, fn task -> render_row(task) end)
          end
        end
      end
    end
  end

  defp render_row(%Task{} = task) do
    table_row do
        table_cell(content: task.title)
        table_cell(content: task.description)
        table_cell(content: task.status)
        table_cell(content: task.priority)
    end
  end
end
