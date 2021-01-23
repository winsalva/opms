defmodule MyAppWeb.TodoLive do
  use MyAppWeb, :live_view



  alias MyApp.Todos


  def mount(_params, _session, socket) do
    {:ok, assign(socket, todos: Todos.list_todos())}
  end


  def render(assigns) do
    ~L"""
      Rendering liveview 
    """
  end
end