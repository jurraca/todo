defmodule Todo.Task.Core do
  @moduledoc """
  Core functions for our Todo list. Either takes in the GenServer tasks state or delegates to the Task module for DB requests.
  """

  alias Todo.Task

  @priorities %{"low" => 0, "medium" => 1, "high" => 2}

  def create(%{title: _title, description: _description, due_date: _due} = params) do
    case all_complete?() do
      true -> Task.create(params)
      false -> {:error, "Cannot create a new task until you finish incomplete tasks!"}
    end
  end

  def list(), do: Task.get_all()

  def sort_list(tasks, :due_date, order) when order in [:desc, :asc] do
    Enum.sort_by(tasks, & &1.due_date, {order, Date})
  end

  def sort_list(tasks, :priority, order) when order in [:desc, :asc] do
    Enum.sort_by(tasks, &sorter(&1.priority), order)
  end

  def filter_priority(tasks, priority) do
    p = String.downcase(priority)
    Enum.filter(tasks, fn t -> t.priority == p end)
  end

  def filter_label(tasks, label) do
    l = String.downcase(label)
    Enum.filter(tasks, fn t -> l in t.labels end)
  end

  def list_by_priority(priority) do
    Task.get_by_priority(priority)
  end

  def list_by_label(label) do
    Task.get_by_label(label)
  end

  def new(params) do
    params
    |> handle_params()
    |> Task.create()
  end

  def update(params) do
    [id, params] = String.split(params, " ", parts: 2)

    id
    |> String.to_integer()
    |> Task.get_by_id()
    |> Task.update(handle_params(params))
  end

  def delete(id) do
    id
    |> Task.get_by_id()
    |> Task.delete()
  end

  def mark_complete(task), do: Task.update(task, %{status: "complete"})

  defp sorter(priority), do: Map.get(@priorities, priority)

  defp all_complete?() do
    Enum.all?(list(), fn task -> task.status == "complete" end)
  end

  defp handle_params(params) do
    params
    |> String.split("--")
    |> Enum.reduce(%{}, fn x, acc -> handle_fields(x, acc) end)
  end

  defp handle_fields(pair, acc) do
    case format_pairs(pair) do
      {k, v} -> Map.put(acc, k, v)
      _ -> acc
    end
  end

  defp format_pairs(pair) do
    pair
    |> String.trim()
    |> String.split(" ", parts: 2)
    |> format_input()
  end

  defp format_input(["title", value | _]) do
    {:title, value}
  end

  defp format_input(["desc", value | _]) do
    {:description, value}
  end

  defp format_input(["due", value | _]) do
    {:ok, dt, 0} = DateTime.from_iso8601(value <> " 00:00:00Z")
    {:due_date, dt}
  end

  defp format_input(["labels", value | _]) when is_binary(value) do
    {:labels, [value]}
  end

  defp format_input(["labels", value | _]) when is_list(value) do
    {:labels, value}
  end

  defp format_input(["priority", value | _]) do
    {:priority, value}
  end

  defp format_input(["status", value | _]) do
    {:status, value}
  end

  defp format_input([""]), do: nil
end
