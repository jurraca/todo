defmodule Todo.CLI do
#  @behaviour Ratatouille.App
#
#  import Ratatouille.View
#  alias Ratatouille.Constants
  alias Todo.Task.Core
  alias Todo.{Task, Server}

  @commands %{
    "quit" => "Quits the app.",
    "list" => "List all tasks.",
    "new" => "Create a new task."
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

  defp execute_cmd("quit") do
    IO.puts("Closing. Go forth and conquer.")
    Server.quit()
  end

  defp execute_cmd("list") do
    Server.list_tasks()
    |> Enum.map(fn task -> render_task(task) end)
  end

  defp render_task(task) do
    ["\n Task: ", task.title, " - due: ", format_date(task.due_date),
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
