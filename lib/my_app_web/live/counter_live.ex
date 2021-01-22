defmodule MyAppWeb.CounterLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.CounterView


  def mount(_session, socket) do
    {:ok, assign(socket, :val, 0)}
  end

  def render(assigns) do
    CounterView.render("index.html", assigns)
  end


  def handle_event("inc", _, socket) do
    {:noreply, update(socket, :val, &(&1+1))}
  end


  def handle_event("dec", _, socket) do
    {:noreply, update(socket, :val, &(&1-1))}
  end
end