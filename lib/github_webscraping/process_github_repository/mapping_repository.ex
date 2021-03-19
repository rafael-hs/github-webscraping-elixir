defmodule GithubWebscraping.ProcessGithubRepository.MappingRepository do
  alias GithubWebscraping.Constants

  @files_repo ""
  @files ""

  def process(url) do
    urls = getUrls(url)

    result =
      Enum.each(urls, fn url ->
        cond do
          is_paste?(url) == true ->
            IO.puts("is a paste")

          is_paste?(url) == false ->
            IO.puts("not a paste")
        end
      end)

    result
  end

  def build_file(url) do
    {:ok, html} = loadStringUrl(url) |> Floki.parse_document()

    archive_name =
      html
      |> Floki.find("div.repository-content")
      |> Floki.find("div.d-flex.flex-items-start.flex-shrink-0")
      |> Floki.find("strong.final-path")
      |> Floki.text()

    archive_name
  end

  def getUrls(url) do
    url
    |> loadStringUrl()
    |> Floki.parse_document!()
    |> Floki.find("div.js-details-container.Details")
    |> Floki.find("div.js-navigation-item")
    |> Floki.find("a.js-navigation-open.Link--primary")
    |> Floki.attribute("href")
  end

  def loadStringUrl(url) do
    HTTPoison.get!(url).body
  end

  def return_line_numbers(lines_input) do
    kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+) lines/, lines_input)))
    kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+)/, kylo_bytes)))
    {lines, _} = Float.parse(kylo_bytes)
    lines
  end

  def return_size_file_in_bytes(string_bytes) do
    cond do
      String.contains?(string_bytes, "KB") ->
        kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+)?.?(\d+) KB/, string_bytes)))

        bytes_regex_escaped =
          String.trim(List.first(List.first(Regex.scan(~r/(\d+)?.?(\d+)/, kylo_bytes))))

        {bytes, _} = Float.parse(bytes_regex_escaped)
        bytes * 1000

      String.contains?(string_bytes, "MB") ->
        kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+)?.?(\d+) MB/, string_bytes)))

        bytes_regex_escaped =
          String.trim(List.first(List.first(Regex.scan(~r/(\d+)?.?(\d+)/, kylo_bytes))))

        {bytes, _} = Float.parse(bytes_regex_escaped)
        bytes * 1_000_000

      String.contains?(string_bytes, "Bytes") ->
        kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+) MB/, string_bytes)))

        bytes_regex_escaped =
          String.trim(List.first(List.first(Regex.scan(~r/(\d+)/, kylo_bytes))))

        {bytes, _} = Float.parse(bytes_regex_escaped)
        bytes
    end
  end

  defp is_paste?(url) do
    url =~ "tree"
  end
end
