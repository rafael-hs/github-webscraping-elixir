defmodule GithubWebscraping.GroupFileInformation do
  @spec group_infos(list(%GithubWebscraping.Schemas.GithubFile{})) :: map()
  def group_infos(files) do
    all_lines = get_all_lines(files)
    all_bytes = get_all_bytes(files)

    repo_info = %{
      all_lines: all_lines,
      all_bytes: all_bytes,
      files: files
    }

    repo_info
  end

  defp get_all_lines(files) do
    all_lines = Enum.reduce(files, 0, fn file, acc -> file.file_lines + acc end)
    all_lines
  end

  defp get_all_bytes(files) do
    all_bytes = Enum.reduce(files, 0, fn file, acc -> file.file_bytes + acc end)

    all_bytes
  end
end
