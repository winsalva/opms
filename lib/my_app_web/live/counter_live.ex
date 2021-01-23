defmodule MyAppWeb.CounterLive do
  use MyAppWeb, :live_view

  alias MyAppWeb.CounterView


  def render(assigns) do
    render(CounterView, "index.html", assigns)
  end

  ## It's mount/3 not mount/2
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :val, 0)}
  end


  def handle_event("inc", _value, socket) do
    {:noreply, update(socket, :val, &(&1+1))}
  end


  def handle_event("dec", _value, socket) do
    {:noreply, update(socket, :val, &(&1-1))}
  end
end