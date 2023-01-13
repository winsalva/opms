defmodule MyApp.Periodically do
  use GenServer

  alias MyApp.Query.ProcurementRequest, as: PR

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    # Schedule work to be performed at some point

    PR.archive_prs
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    # Reschedule once more

    PR.archive_prs
    schedule_work()
    {:noreply, state}
  end

  # 86400 * 1000 * 365 = 1 year
  defp schedule_work() do
    Process.send_after(self(), :work, 86400 * 1000 * 365)
  end
end