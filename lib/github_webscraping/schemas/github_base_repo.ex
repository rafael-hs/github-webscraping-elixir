defmodule GithubWebscraping.Schemas.GithubBaseRepo do
  alias GithubWebscraping.Schemas.GithubBaseRepo

  defstruct [:base_url, :pastes_url]

  def build(base_url, pastes_url) do
    %GithubBaseRepo{
      base_url: base_url,
      pastes_url: pastes_url
    }
  end
end
