defmodule GithubWebscraping.MappingRepository do
  alias GithubWebscraping.ExtractFileInfos
  alias GithubWebscraping.Schemas.GithubFile
  alias GithubWebscraping.Constants

  def process(url) do
    url = is_first_url(url)
    urls = getUrls(url)
    files_url = get_files_url(urls)
    pastes_url = get_pastes_url(urls)

    files =
      Enum.map(files_url, fn file_url ->
        build_file(Constants.git_url_base() <> file_url)
      end)

    IO.inspect(files)
    IO.inspect(pastes_url)

    other_files =
      if Enum.count(pastes_url) > 0 do
        Enum.map(pastes_url, fn url ->
          process(url)
        end)
      else
        []
      end

    IO.inspect(Enum.count(other_files))

    if Enum.count(other_files) > 0 do
      Enum.concat(files, Enum.reduce(other_files, fn elem, acc -> elem ++ acc end))
    else
      files
    end
  end

  def build_file(url) do
    html = loadStringUrl(url) |> Floki.parse_document!()
    name = ExtractFileInfos.fetch_file_name(html)
    IO.inspect(name)
    lines = ExtractFileInfos.fetch_line_numbers(html)
    extension = ExtractFileInfos.fetch_extension(html)
    bytes = ExtractFileInfos.fetch_file_size_in_bytes(html)

    GithubFile.build(url, name, extension, bytes, lines)
  end

  defp getUrls(url) do
    url
    |> loadStringUrl()
    |> Floki.parse_document!()
    |> Floki.find("div.js-details-container.Details")
    |> Floki.find("div.js-navigation-item")
    |> Floki.find("a.js-navigation-open.Link--primary")
    |> Floki.attribute("href")
  end

  defp loadStringUrl(url) do
    HTTPoison.get!(url).body
  end

  defp get_files_url(urls) do
    Enum.filter(urls, fn url -> url =~ "blob" end)
  end

  defp get_pastes_url(urls) do
    Enum.filter(urls, fn url -> url =~ "tree" end)
  end

  defp is_first_url(url) do
    if url =~ "https://github.com/" do
      url
    else
      "https://github.com" <> url
    end
  end
end
