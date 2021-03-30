defmodule GithubWebscraping.ExtractFileInfos do
  def fetch_file_name(html) do
    file_name =
      html
      |> Floki.find("div.repository-content")
      |> Floki.find("div.d-flex.flex-items-start.flex-shrink-0")
      |> Floki.find("strong.final-path")
      |> Floki.text()

    file_name
  end

  def fetch_extension(html) do
    file_name =
      html
      |> Floki.find("div.repository-content")
      |> Floki.find("div.d-flex.flex-items-start.flex-shrink-0")
      |> Floki.find("strong.final-path")
      |> Floki.text()

    Path.extname(file_name)
  end

  def fetch_line_numbers(html) do
    line_numbers =
      html
      |> Floki.find("div.text-mono.f6.flex-auto.pr-3")
      |> Floki.text()

    if String.contains?(line_numbers, "sloc") do
      kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+) lines/, line_numbers)))
      kylo_bytes = List.first(List.first(Regex.scan(~r/(\d+)/, kylo_bytes)))
      {lines, _} = Integer.parse(kylo_bytes)
      lines
    else
      0
    end
  end

  def fetch_file_size_in_bytes(html) do
    string_bytes =
      html
      |> Floki.find("div.text-mono.f6.flex-auto.pr-3")
      |> Floki.text()

    cond do
      String.contains?(string_bytes, "KB") ->
        k_bytes = String.trim(List.last(List.last(Regex.scan(~r/(\d+)?.?(\d+)/, string_bytes))))
        {bytes, _} = Float.parse(k_bytes)
        bytes * 1000.0

      String.contains?(string_bytes, "MB") ->
        m_bytes = String.trim(List.last(List.last(Regex.scan(~r/(\d+)?.?(\d+)/, string_bytes))))
        {bytes, _} = Float.parse(m_bytes)
        bytes * 1_000_000.0

      String.contains?(string_bytes, "Bytes") ->
        bytes = String.trim(List.last(List.last(Regex.scan(~r/(\d+)/, string_bytes))))
        {bytes, _} = Float.parse(bytes)
        bytes
    end
  end
end
