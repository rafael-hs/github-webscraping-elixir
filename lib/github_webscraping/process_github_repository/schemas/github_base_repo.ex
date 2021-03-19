defmodule GithubWebscraping.ProcessGithubRepository.Schemas.GithubBaseRepo do
  alias GithubWebscraping.ProcessGithubRepository.Schemas

  defstruct [:base_url, :pastes_url]

  def build(base_url, pastes_url) do
    %Schemas.GithubBaseRepo{
      base_url: base_url,
      pastes_url: pastes_url
    }
  end
end
