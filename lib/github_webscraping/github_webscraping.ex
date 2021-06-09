defmodule GitGithubWebscraping.GithubWebscraping do
  @moduledoc """
  GithubWebscraping API module
  """
  alias GithubWebscraping.Process.ExtractRepositoryInfo

  defdelegate get_repository_infos(url), to: ExtractRepositoryInfo, as: :run
end
