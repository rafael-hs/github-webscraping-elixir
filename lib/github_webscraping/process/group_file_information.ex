defmodule GithubWebscraping.Process.GroupFileInformation do
  @spec group_infos([%GithubWebscraping.Schemas.GithubFile{}]) :: map()
  def group_infos(files) do
    all_lines = get_all_lines(files)
    all_bytes = get_all_bytes(files)

    %{
      all_lines: all_lines,
      all_bytes: all_bytes,
      files: files
    }
  end

  defp get_all_lines(files) do
    Enum.reduce(files, 0, fn file, acc -> file.file_lines + acc end)
  end

  defp get_all_bytes(files) do
    Enum.reduce(files, 0, fn file, acc -> file.file_bytes + acc end)
  end
end
