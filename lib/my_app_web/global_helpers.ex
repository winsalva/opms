defmodule MyAppWeb.GlobalHelpers do

  @doc """
  Return CSS class based on given PR status.
  """
  def get_css_class(status) do
    case status do
      "Delivery of Items" -> "color-green"
      "Failed Purchase Request" -> "color-red"
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
    "#{date.year}-#{date.month}-#{date.day}"
  end

  def get_datetime(date) do
    y = date.year
    m = date.month
    d = date.day
    h = date.hour + 8
    ms = date.minute

    if h > 11 do
      "#{y}-#{m}-#{d} : #{h-12}:#{ms} pm"
    else
      "#{y}-#{m}-#{d} : #{h}:#{ms} am"
    end
  end
end