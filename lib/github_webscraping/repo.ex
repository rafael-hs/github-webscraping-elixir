defmodule GithubWebscraping.Repo do
  use Ecto.Repo,
    otp_app: :github_webscraping,
    adapter: Ecto.Adapters.Postgres
end
