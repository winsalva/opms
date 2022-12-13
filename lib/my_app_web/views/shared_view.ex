defmodule MyAppWeb.SharedView do
  use MyAppWeb, :view

  alias MyApp.Query.Company

  def get_new_registers do
    Company.new_registers
  end
end