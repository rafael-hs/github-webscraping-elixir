defmodule GithubWebscrapingWeb.PageController do
  use GithubWebscrapingWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
