defmodule MyAppWeb.Procurement.AccountView do
  use MyAppWeb, :view

  def process_done(status) do
    case status do
      "Delivered Items" -> true
      "Issued Notice To Proceed" -> true
      "Failed Purchase Request" -> true
      _statuses -> false
    end
  end

  def get_next_alternative_status(status) do
    case status do
      "Received Purchase Request" -> ["Posted Purchase Request (greater than 50k)": "Posted Purchase Request", "Prepared Request For Quotation": "Prepared Request For Quotation", "Failed Purchase Request": "Failed Purchase Request"]
      "Posted Purchase Request" -> ["Prepared Request For Quotation": "Prepared Request For Quotation", "Failed Purchase Request": "Failed Purchase Request"]
      "Prepared Request For Quotation" -> ["Opened Request For Quotation": "Opened Request For Quotation", "Failed Purchase Request": "Failed Purchase Request"]
      "Opened Request For Quotation" -> ["Prepared Abstract Of Quotation": "Prepared Abstract Of Quotation", "Failed Purchase Request": "Failed Purchase Request"]
      "Prepared Abstract Of Quotation" -> ["Prepared Purchase Order": "Prepared Purchase Order", "Failed Purchase Request": "Failed Purchase Request"]
      "Prepared Purchase Order" -> ["Served Purchase Order": "Served Purchase Order", "Failed Purchase Request": "Failed Purchase Request"]
      "Served Purchase Order" -> ["Delivered Items": "Delivered Items", "Failed Purchase Request": "Failed Purchase Request"]
    end
  end

  def get_next_competitive_status(status) do
    case status do
      "Conducted Pre-Procurement Assessment" -> ["Invited Bidders": "Invited Bidders", "Failed Purchase Request": "Failed Purchase Request"]
      "Invited Bidders" -> ["Conducted Pre-bid Conference": "Conducted Pre-bid Conference", "Failed Purchase Request": "Failed Purchase Request"]
      "Conducted Pre-bid Conference" -> ["Receipt & Opened Bids": "Receipt & Opened Bids", "Failed Purchase Request": "Failed Purchase Request"]
      "Receipt & Opened Bids" -> ["Bid Evaluated": "Bid Evaluated", "Failed Purchase Request": "Failed Purchase Request"]
      "Bid Evaluated" -> ["Posted Qualification": "Posted Qualification", "Failed Purchase Request": "Failed Purchase Request"]
      "Posted Qualification" -> ["Noticed & Executed Award": "Noticed & Executed Award", "Failed Purchase Request": "Failed Purchase Request"]
      "Noticed & Executed Award" -> ["Contract Prepared & Signed": "Contract Prepared & Signed", "Failed Purchase Request": "Failed Purchase Request"]
      "Contract Prepared & Signed" -> ["Issued Notice To Proceed": "Issued Notice To Proceed", "Failed Purchase Request": "Failed Purchase Request"]
    end
  end

  def get_next_status(bid_mode, status) do
    case bid_mode do
      "Alternative" -> get_next_alternative_status(status)
      _competitive  -> get_next_competitive_status(status)
    end
  end
end