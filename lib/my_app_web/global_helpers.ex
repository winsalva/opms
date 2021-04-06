defmodule MyAppWeb.GlobalHelpers do


  @doc """
  Gets the current year
  """
  def current_year do
    date = Date.utc_today()
    date.year
  end
end