defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view

  alias MyApp.Todos


  def mount(_params, _session, socket) do
    IO.inspect socket
    {:ok, assign(socket, todos: Todos.list_todos())}
  end


  def handle_event("add", %{"todo" => todo}, socket) do
    Todos.create_todo(todo)
    {:noreply, assign(socket, todos: Todos.list_todos())}
   end
end