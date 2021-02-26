defmodule Todo.Server do
  @moduledoc """
  Boundary endpoints for our application, with a public API.
  """
  use GenServer
  alias Todo.Task.Core

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Boundary)
  end

  def list_tasks() do
    GenServer.call(Boundary, :list)
  end

  def sort_tasks_by_priority(order) do
    GenServer.call(Boundary, {:sort, :priority, order})
  end

  def sort_tasks_by_date(order) do
    GenServer.call(Boundary, {:sort, :due_date, order})
  end

  def list_by_priority(priority) do
    GenServer.call(Boundary, {:list, :priority, priority})
  end

  def list_by_label(label) do
    GenServer.call(Boundary, {:list, :label, label})
  end

  def new_task(params) do
    GenServer.call(Boundary, {:new, params})
  end

  def delete_task(id) do
    GenServer.cast(Boundary, {:delete, id})
  end

  def update_task(params) do
    GenServer.cast(Boundary, {:update, params})
  end

  def quit() do
    System.stop(0)
  end

  @impl true
  def init(_opts) do
    tasks = Core.list()
    {:ok, tasks}
  end

  @impl true
  def handle_call(:list, _from, tasks) do
    {:reply, tasks, tasks}
  end

  @impl true
  def handle_call({:sort, sort_field, order}, _from, tasks) do
    sorted = Core.sort_list(tasks, sort_field, order)
    {:reply, sorted, tasks}
  end

  @impl true
  def handle_call({:list, :priority, priority}, _from, tasks) do
    {:reply, Core.filter_priority(tasks, priority), tasks}
  end

  @impl true
  def handle_call({:list, :label, label}, _from, tasks) do
    {:reply, Core.filter_label(tasks, label), tasks}
  end

  @impl true
  def handle_call({:new, params}, _from, _tasks) do
    case Core.new(params) do
      {:ok, _} -> {:reply, :ok, Core.list()}
      {:error, _} -> {:reply, :error, Core.list()}
    end
  end

  @impl true
  def handle_cast({:delete, id}, _tasks) do
    case Core.delete(id) do
      {:ok, _} -> :ok
      {:error, reason} -> reason
    end

    {:noreply, Core.list()}
  end

  def handle_cast({:update, params}, tasks) do
    case Core.update(params) do
      {:ok, _} -> {:noreply, Core.list()}
      {:error, _} -> {:noreply, tasks}
    end
  end

  @impl true
  def terminate(reason, state) do
    {reason, state}
  end
end
