defmodule GithubWebscraping.ProcessGithubRepository.Schemas.GithubFile do
  alias GithubWebscraping.ProcessGithubRepository.Schemas

  defstruct [:file_url, :file_name, :extension, :file_bytes, :file_lines]

  def build(file_url, file_name, extension, file_bytes, file_lines) do
    %Schemas.GithubFile{
      file_url: file_url,
      file_name: file_name,
      extension: extension,
      file_bytes: file_bytes,
      file_lines: file_lines
    }
  end
end
