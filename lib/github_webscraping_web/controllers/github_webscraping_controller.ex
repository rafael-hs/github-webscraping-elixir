defmodule GithubWebscrapingWeb.GithubWebscrapingController do
  use GithubWebscrapingWeb, :controller

  alias GitGithubWebscraping.GithubWebscraping

  def show(conn, %{"github_url" => github_url}) do
    files = GithubWebscraping.get_repository_infos(github_url)
    json(conn, files)
  end
end
