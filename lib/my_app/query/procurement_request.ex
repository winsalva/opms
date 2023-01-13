defmodule MyApp.Query.ProcurementRequest do
  @moduledoc """
  Documentation for Procurement Request.
  """

  alias MyApp.Repo
  alias MyApp.Schema.ProcurementRequest, as: PR
  alias MyApp.Schema.PrsRemark, as: Remark
  alias MyApp.Query.Company

  import Ecto.Query, warn: false

  def list_archived_prs do
    query =
      from pr in PR,
        where: pr.archive == true,
	order_by: [asc: :inserted_at],
	preload: [:company]

    Repo.all(query)
  end

  def sort_ongoing_department_prs(department_id, q_string) do
    query_string =
      case q_string do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end
    
    query =
      from pr in PR,
        where: pr.company_id == ^department_id and pr.status != "Delivered Items" and pr.status != "Failed Purchase Request" and pr.status != "Issued Notice To Proceed" and pr.archive == false,
	order_by: [asc: ^query_string],
	preload: [:company]

    Repo.all(query)
  end

  def sort_failed_department_prs(department_id, q_string) do
    query_string =
      case q_string do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    query =
      from pr in PR,
        where: pr.company_id == ^department_id and pr.status == "Failed Purchase Request",
        order_by: [asc: ^query_string],
        preload: [:company]

    Repo.all(query)
  end

  @doc """
  Sort completed prs of a department.
  """
  def sort_completed_department_prs(department_id, q_string) do
    query_string =
      case q_string do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    query =
      from pr in PR,
        where: (pr.company_id == ^department_id and pr.status == "Delivered Items") or (pr.company_id == ^department_id and pr.status == "Issued Notice To Proceed"),
        order_by: [asc: ^query_string],
        preload: [:company]

    Repo.all(query)
  end

  @doc """
  Sort archived prs of a department.
  """
  def sort_archived_department_prs(department_id, q_string) do
    query_string =
      case q_string do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    query =
      from pr in PR,
        where: pr.company_id == ^department_id and pr.archive == true,
        order_by: [asc: ^query_string],
        preload: [:company]

    Repo.all(query)
  end
  
  def new_pr do
    %PR{}
    |> PR.changeset()
  end

  def insert_pr(params) do
    %PR{}
    |> PR.changeset(params)
    |> Repo.insert()
  end

  def get_pr_with_remarks(id) do
    query =
      from p in PR,
        where: p.id == ^id,
	preload: [:company, prs_remarks: :admin]
	
    Repo.one(query)
  end

  @doc """
  Sort PRs by month.
  """
  def sort_prs_by_month(sort_by, q_string, user, user_id) do
    sorted_by =
      case sort_by do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    q_str = String.upcase(q_string)
    
    month =
      cond do
        String.starts_with?(q_str, "JAN") -> 1
	String.starts_with?(q_str, "JAN") -> 2
	String.starts_with?(q_str, "JAN") -> 3
	String.starts_with?(q_str, "JAN") -> 4
	String.starts_with?(q_str, "JAN") -> 5
	String.starts_with?(q_str, "JAN") -> 6
	String.starts_with?(q_str, "JAN") -> 7
	String.starts_with?(q_str, "JAN") -> 8
	String.starts_with?(q_str, "JAN") -> 9
	String.starts_with?(q_str, "JAN") -> 10
	String.starts_with?(q_str, "JAN") -> 11
	String.starts_with?(q_str, "JAN") -> 12
	true -> 0
      end

    query =
    if user == "Admin" do
      query =
        from p in PR,
          order_by: [asc: ^sorted_by],
          preload: [:company]
    else
      query =
        from p in PR,
	  where: p.company_id == ^user_id,
          order_by: [asc: ^sorted_by],
          preload: [:company]
    end

    prs = Repo.all(query)

    result =
    case prs do
      [] -> []
      _prs ->
        Enum.reduce(prs, [], fn f, acc ->
          if f.inserted_at.month == month do
            [f | acc]
          else
            acc
          end
        end)
    end
    Enum.reverse(result)
  end

  @doc """
  Sort PRs by year.
  """
  def sort_prs_by_year(sort_by, year, user, user_id) do
    sorted_by =
      case sort_by do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    query =
    if user == "Admin" do
      query =
        from p in PR,
          order_by: [asc: ^sorted_by],
          preload: [:company]
    else
      query =
        from p in PR,
          where: p.company_id == ^user_id,
          order_by: [asc: ^sorted_by],
          preload: [:company]
    end

    prs = Repo.all(query)

    result =
    case prs do
      [] -> []
      _prs ->
        Enum.reduce(prs, [], fn f, acc ->
	  if f.inserted_at.year == String.to_integer(year) do
	    [f | acc]
	  else
	    acc
	  end
	end)
    end
    Enum.reverse(result)
    
  end

  @doc """
  Search pr for admin
  """
  def admin_search_pr(category, sort_by, q_string) do
    sorted_by =
      case sort_by do
        "Date Needed" -> :date_needed
	"Date Created" -> :inserted_at
	"Date Updated" -> :updated_at
      end
      
    case category do
      "Year" -> sort_prs_by_year(sort_by, q_string, "Admin", 0)

        "Month" -> sort_prs_by_month(sort_by, q_string, "Admin", 0)
	"Ongoing PRs" ->
	  query =
	    from p in PR,
	      where: p.status != "Delivered Items" and p.status != "Failed Purchase Request" and p.status != "Issued Notice To Proceed",
	      order_by: [asc: ^sorted_by],
	      preload: [:company]
	  Repo.all(query)

        "Failed PRs" ->
	  query =
	    from p in PR,
	      where: p.status == "Failed Purchase Request",
	        order_by: [asc: ^sorted_by],
		preload: [:company]
	  Repo.all(query)
	    
	"Completed PRs" ->
	  query =
	    from p in PR,
	      where: p.status == "Delivered Items" or p.status == "Issued Notice To Proceed",
	        order_by: [asc: ^sorted_by],
		preload: [:company]
	  Repo.all(query)

        "Department" ->
	    company = Company.get_company_by(%{department: q_string})
	    case company do
	      nil -> []
	      _company ->
	      company_id = company.id
	      query =
	      from p in PR,
	        where: p.company_id == ^company_id,
		order_by: [asc: ^sorted_by],
		preload: [:company]

            Repo.all(query)
	  end
	    
	"PR ID" ->
	  query =
	    from p in PR,
	      where: p.pr_number == ^q_string,
	      preload: [:company]

          Repo.all(query)
    end
  end
  

  @doc """
  Search procurement request by id but only for procurement request that belongs to a user.
  """
  def user_search_pr(category, sort_by, q_string, user_id) do
    sorted_by =
      case sort_by do
        "Date Needed" -> :date_needed
        "Date Created" -> :inserted_at
        "Date Updated" -> :updated_at
      end

    case category do
      "Year" -> sort_prs_by_year(sort_by, q_string, "User", user_id)

        "Month" -> sort_prs_by_month(sort_by, q_string, "User", user_id)
        "Ongoing PRs" ->
          query =
            from p in PR,
              where: p.company_id == ^user_id and p.status != "Delivered Items" and p.status != "Failed Purchase Request" and p.status != "Issued Notice To Proceed",
              order_by: [asc: ^sorted_by],
              preload: [:company]
          Repo.all(query)
	"Failed PRs" ->
          query =
            from p in PR,
              where: p.company_id == ^user_id and p.status == "Failed Purchase Request",
                order_by: [asc: ^sorted_by],
                preload: [:company]
          Repo.all(query)

        "Completed PRs" ->
          query =
            from p in PR,
              where: p.company_id == ^user_id and p.status == "Delivered Items" or p.status == "Issued Notice To Proceed",
                order_by: [asc: ^sorted_by],
                preload: [:company]
          Repo.all(query)

	"PR ID" ->
          query =
            from p in PR,
              where: p.company_id == ^user_id and p.pr_number == ^q_string,
              preload: [:company]

          Repo.all(query)
    end
  end


  def list_prs do
    query =
      from p in PR,
        preload: [:company, :pr_personnel]

    Repo.all(query)
  end

  def list_ongoing_prs do
    query =
      from p in PR,
        where: p.status != "Delivered Items" and p.status != "Failed Purchase Request" and p.status != "Issued Notice To Proceed" and p.archive == false,
	preload: [:company, :pr_personnel]

    Repo.all(query)
  end

  def list_succeeded_prs do
    query =
      from p in PR,
        where: p.status == "Delivered Items" or p.status == "Issued Notice To Proceed",
        preload: [:company, :pr_personnel]

    Repo.all(query)
  end

  def list_failed_prs do
    query =
      from p in PR,
        where: p.status == "Failed Purchase Request",
        preload: [:company, :pr_personnel]

    Repo.all(query)
  end

  def get_pr(id) do
    Repo.get(PR, id)
  end

  def edit_pr(id) do
    get_pr(id)
    |> PR.changeset()
  end

  def update_pr(id, params) do
    get_pr(id)
    |> PR.changeset(params)
    |> Repo.update()
  end

  def archive_prs do
    query =
      from p in PR,
        where: p.status != "Delivered Items" and p.status != "Failed Purchase Request" and p.status != "Issued Notice To Proceed" and p.archive == false

    prs = Repo.all(query)

    if prs != [] do
      for p <- prs do
        update_pr(p.id, %{archive: true})
      end
    end
  end

  def delete_pr(id) do
    get_pr(id)
    |> Repo.delete()
  end
end