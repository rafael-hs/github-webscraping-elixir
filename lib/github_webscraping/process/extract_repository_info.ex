defmodule GithubWebscraping.Process.ExtractRepositoryInfo do
  alias GithubWebscraping.Process.{ExtractFileInfos, GroupFileInformation}
  alias GithubWebscraping.Schemas.GithubFile

  @git_url_base "https://github.com"

  @spec run(String.t()) :: map()
  def run(url) do
    url
    |> mapping_repository_by_url()
    |> GroupFileInformation.group_infos()
  end

  defp mapping_repository_by_url(url) do
    urls =
      url
      |> first_url?()
      |> get_urls()

    files_url = get_files_url(urls)
    pastes_url = get_directories_url(urls)

    files =
      files_url
      |> Task.async_stream(
        fn file_url ->
          try do
            build_file(@git_url_base <> file_url)
          catch
            error -> IO.inspect(error)
          end
        end,
        timeout: :infinity
      )
      |> Enum.map(&elem(&1, 1))

    IO.puts("\n----------Returned files----------\n")
    IO.inspect(files)
    IO.puts("\n----------Returned urls-----------\n")
    IO.inspect(pastes_url)

    other_files =
      if Enum.count(pastes_url) > 0 do
        Enum.map(pastes_url, fn url ->
          mapping_repository_by_url(url)
        end)
      else
        []
      end

    if Enum.count(other_files) > 0 do
      Enum.concat(files, Enum.reduce(other_files, fn elem, acc -> elem ++ acc end))
    else
      files
    end
  end

  defp build_file(url) do
    html = download_string_url(url)
    name = ExtractFileInfos.fetch_file_name(html)
    lines = ExtractFileInfos.fetch_line_numbers(html)
    extension = ExtractFileInfos.fetch_extension(html)
    bytes = ExtractFileInfos.fetch_file_size_in_bytes(html)

    GithubFile.build(url, name, extension, bytes, lines)
  end

  defp get_urls(url) do
    url
    |> download_string_url()
    |> Floki.parse_document!()
    |> Floki.find("div.js-details-container.Details")
    |> Floki.find("div.js-navigation-item")
    |> Floki.find("a.js-navigation-open.Link--primary")
    |> Floki.attribute("href")
  end

  def download_string_url(url) do
    HTTPoison.get!(url).body
  end

  defp get_files_url(urls) do
    Enum.filter(urls, fn url -> url =~ "blob" end)
  end

  defp get_directories_url(urls) do
    Enum.filter(urls, fn url -> url =~ "tree" end)
  end

  defp first_url?(url) do
    if url =~ "https://github.com/" do
      url
    else
      "https://github.com" <> url
    end
  end
end
