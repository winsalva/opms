defmodule MyAppWeb.GlobalHelpers do

  @doc """
  Return CSS class based on given PR status.
  """
  def get_css_class(status) do
    case status do
      "Delivery of Items" -> "color-green"
      "Failed PR" -> "color-red"
      _ -> "color-yellow"
    end
  end

  @doc """
  Gets the current year
  """
  def current_year do
    date = Date.utc_today()
    date.year
  end

  def app_name do
    "SLSU"
  end

  def get_date(date) do
    "#{date.month}-#{date.day}-#{date.year}"
  end
end