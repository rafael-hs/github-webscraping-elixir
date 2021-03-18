defmodule GithubWebscraping.Schemas.GithubFile do
  defstruct(
    file_url: nil,
    file_name: nil,
    extension: nil,
    file_bytes: nil,
    file_lines: nil
  )
end
