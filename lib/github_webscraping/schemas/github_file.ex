defmodule GithubWebscraping.Schemas.GithubFile do
  alias GithubWebscraping.Schemas.GithubFile

  @derive {Jason.Encoder, only: [:file_url, :file_name, :extension, :file_bytes, :file_lines]}
  defstruct [:file_url, :file_name, :extension, :file_bytes, :file_lines]

  @spec build(String.t(), String.t(), String.t(), String.t(), integer()) :: %GithubFile{}
  def build(file_url, file_name, extension, file_bytes, file_lines) do
    %GithubFile{
      file_url: file_url,
      file_name: file_name,
      extension: extension,
      file_bytes: file_bytes,
      file_lines: file_lines
    }
  end
end
