defmodule MyAppWeb.Router do
  use MyAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug MyAppWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end


  scope "/", MyAppWeb do
    pipe_through :browser

    # get "/*default_page", PageController, :under_maintenance
    get "/tests", PageController, :test
    get "/", PageController, :index
    get "/about-us", PageController, :about_us
    get "/terms-of-use", PageController, :term_of_use
    get "/privacy-policy", PageController, :privacy_policy
    get "/contact-us", PageController, :contact_us
    get "/data-entries/departments", PageController, :departments
    get "/data-entries/procurements", PageController, :prs
    
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end


  ## PROCUMENT REQUEST ROUTES ##
  scope "/procurements", MyAppWeb.Procurement, as: :pr do
    pipe_through [:browser]

    get "/on-going/requests", AccountController, :ongoing_prs
    post "/on-going/requests", AccountController, :sort_ongoing_prs 

    resources "/requests", AccountController, only: [:new, :show, :create, :edit, :update, :delete]

    resources "/end_users/requests", PageController, only: [:index, :show]

    get "/search", PageController, :search
    post "/search", PageController, :search_pr

    get "/failed/procurement-requests", PageController, :failed_prs
    post "/failed/procurement-requests", PageController, :sort_failed_prs
    get "/succeeded/procurement-requests", PageController, :succeeded_prs
    post "/succeeded/procurement-requests", PageController, :sort_succeeded_prs
    get "/archived/procurement-requests", PageController, :archived_prs
    post "/archived/procurement-requests", PageController, :sort_archived_prs
    get "/generated-reports", PageController, :generated_report
  end


  ## TRANSACTION ROUTES ##
  scope "/transactions", MyAppWeb.Transaction, as: :transaction do
    pipe_through [:browser]

    get "/new/:item_id", PageController, :new_transaction
    get "/active", PageController, :active_transactions
    get "/success", PageController, :success_transactions
    get "/canceled", PageController, :canceled_transactions
    get "/view-transactions/:id", PageController, :view_transaction
    post "/negotiations", PageController, :create_negotiation
    post "/", PageController, :create_transaction
    post "/update/:id", PageController, :update_transaction
  end


  ## USER ROUTES ##

  scope "/users", MyAppWeb.User, as: :user do
    pipe_through [:browser]

    get "/list-purchase-officers", PageController, :list_purchase_officers
    get "/list-budget-officers", PageController, :list_budget_officers
    get "/list-inventory-officers", PageController, :list_inventory_officers

    resources "/", PageController, only: [
      :new, :create, :show, :index
    ]
    get "/personnels/purchaser/new", AccountController, :new_purchaser
    get "/personnels/budget-officer/new", AccountController, :new_budget_officer
    get "/personnels/inventory-officer/new", AccountController, :new_inventory_officer
    
    post "/personnels/purchaser/", AccountController, :create_purchaser
    post "/personnels/budget-officer/", AccountController, :create_budget_officer
    post "/personnels/inventory-officer/", AccountController, :create_inventory_officer
    get "/personnels/:id", AccountController, :index
    get "/accounts/:id", AccountController, :show
  end

  ## Department ROUTES ##
  scope "/departments", MyAppWeb.Company, as: :company do
    pipe_through :browser

    get "/accounts/:id", AccountController, :account
    get "/accounts/:id/edit", AccountController, :edit_account
    put "/accounts", AccountController, :update_account

    get "/accounts/notify/:email", AccountController, :notify_account

    get "/approved-accounts", AccountController, :approved_companies
    get "/unapproved-accounts", AccountController, :unapproved_companies
    post "/approve-accounts/:id", AccountController, :approve_company
    post "/cancel-approvals/:id", AccountController, :disapprove_company

    resources "/", PageController, only: [
      :new, :create, :show, :index, :delete
    ]
   
  end

  ## ITEMS ROUTES ##
  scope "/products-and-services", MyAppWeb.Item, as: :item do
    pipe_through :browser

    post "/items/:id", PageController, :item
    get "/items-to-buy", PageController, :items_to_buy
    get "/items-to-sell", PageController, :items_to_sell
 
    resources "/", PageController, only: [
      :new, :create, :show, :index
    ]
  end


  ## Home ##
  scope "/*home", MyAppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
  

  # Other scopes may use custom stacks.
  # scope "/api", MyAppWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MyAppWeb.Telemetry
    end
  end
end
