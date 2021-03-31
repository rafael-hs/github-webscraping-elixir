defmodule Lib.GithubWebscraping do
  @moduledoc """
  GithubWebscraping API module
  """
  alias GithubWebscraping.MappingRepository

  defdelegate get_repository_infos(url), to: MappingRepository, as: :process
end
