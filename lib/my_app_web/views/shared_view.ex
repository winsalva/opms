defmodule MyAppWeb.SharedView do
  use MyAppWeb, :view

  alias MyApp.Query.Company

  @doc """
  Function to get the number of newly registers that are not seen yet by admin.
  """
  def get_new_registers do
    Company.new_registers
  end

  def get_number_of_pr_updates_for_user(user_id) do
    prs = Company.get_company_with_procurement_request(user_id)
    result = 
    for pr <- prs.procurement_request do
      pr.update_count
    end

    Enum.sum(result)
  end
end