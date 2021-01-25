defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  alias MyApp.Todos


  def mount(_params, _session, %{assigns: %{live_action: :index}} = socket) do
    Todos.subscribe()
    
    {:ok, fetch(socket)}
  end


  def mount(_params, _session, %{assigns: %{live_action: :register}} = socket) do
    {:ok, fetch(socket)}
  end


  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)
    {:noreply, fetch(socket)}
   end


  def handle_info({Todos, [:todo|_], _}, socket) do
    {:noreply, fetch(socket)}
  end
  

  defp fetch(socket) do
    assign(socket, todos: Todos.list_todos())
  end
end