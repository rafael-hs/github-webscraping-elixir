defmodule GithubWebscrapingWeb.GithubWebscrapingController do
  use GithubWebscrapingWeb, :controller

  alias Lib.GithubWebscraping

  def index(conn, %{"github_url" => github_url}) do
    files = GithubWebscraping.get_repository_infos(github_url)
    json(conn, files)
  end
end
