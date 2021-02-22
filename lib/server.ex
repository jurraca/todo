defmodule Todo.Server do
    use GenServer
    alias Todo.Task.Core

    def start_link(opts) do
      GenServer.start_link(__MODULE__, opts, name: Boundary)
    end

    def list_tasks() do
      GenServer.call(Boundary, :list)
    end

    def quit() do
      System.stop(0)
    end

    @impl true
    def init(opts) do
        {:ok, opts}
    end

    @impl true
    def handle_call(:list, _from, _tasks) do
        tasks = Core.list()
        {:reply, tasks, tasks}
    end

    @impl true
    def terminate(reason, state) do
      {reason, state}
    end
end
