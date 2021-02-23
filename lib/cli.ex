defmodule Todo.CLI do
  @moduledoc """
  CLI commands for the Todo app.
  """
  alias Todo.Server

  @commands %{
    "help" => "Launch this help menu.",
    "list" => "List all tasks.",
    "quit" => "Quits the app.",
    "new" => "Create a new task.
        \n      Syntax: new --title {title} --desc {description} --due {date}
        \n      The title, description, and due date (in the YYYY-MM-DD format) fields are required upon creation.
        \n      You can optionally pass one or more labels, and a priority (low, medium, high).\n ",
    "update" => "Update an existing task. Reference the task by the provided ID. You may update any available field, except the ID.
        \n      Syntax: update {ID} --{field} {updated value}
        \n      Example: update 9 --due 2021-12-31. \n",
    "complete" => "Mark a given task as complete. Syntax: complete {ID}"
  }

  def main(_args) do
    IO.puts("Loaded.")
    execute_cmd("list")
    recv_cmd()
  end

  defp recv_cmd() do
    IO.gets("\n> ")
    |> String.trim
    |> String.downcase
    |> execute_cmd()

    recv_cmd()
  end

  defp execute_cmd(""), do: nil

  defp execute_cmd("help") do
    @commands
    |> Enum.map(fn { k, v } -> "\n " <> k <> " -> " <> v end)
    |> IO.puts()
  end

  defp execute_cmd("quit") do
    IO.puts("Closing. Go forth and conquer.")
    Server.quit()
  end

  defp execute_cmd("list") do
    Server.list_tasks()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp execute_cmd("list priority:asc") do
    execute_cmd("list priority", :asc)
  end

  defp execute_cmd("list priority:desc") do
    execute_cmd("list priority", :desc)
  end

  defp execute_cmd("list priority", order) do
    order
    |> Server.sort_tasks_by_priority()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp execute_cmd("list due:asc") do
    execute_cmd("list due", :asc)
  end

  defp execute_cmd("list due:desc") do
    execute_cmd("list due", :desc)
  end

  defp execute_cmd("list due", order) do
    order
    |> Server.sort_tasks_by_date()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp execute_cmd("list priority " <> priority) do
    priority
    |> Server.list_by_priority()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp execute_cmd("list label " <> label) do
    label
    |> Server.list_by_label()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp render_task(task) do
    ["\nTask: ", task.title, " - due: ", format_date(task.due_date),
    "\n -> Desc: ", task.description,
    "\n -> Status: ", String.upcase(task.status),
    "\n -> Labels: ", format_labels(task.labels),
    "\n -> Priority: ", String.upcase(task.priority)
  ]
    |> IO.puts()
  end

  defp format_date(date) do
    date
    |> DateTime.to_string()
    |> String.split()
    |> Enum.at(0)
  end

  defp format_labels(nil), do: ""

  defp format_labels(labels), do: Enum.join(labels, ", ")
end
