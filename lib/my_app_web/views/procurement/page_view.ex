defmodule MyAppWeb.Procurement.PageView do
  use MyAppWeb, :view

  def process_done(status) do
    case status do
      "Delivered Items" -> true
      "Issued Notice To Proceed" -> true
      "Failed Purchase Request" -> true
      _statuses -> false
    end
  end
end