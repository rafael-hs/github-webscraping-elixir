defmodule GithubWebscraping.ExtractFileInfos do
  @spec fetch_file_name(String.t()) :: binary()
  def fetch_file_name(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("div.repository-content")
    |> Floki.find("div.d-flex.flex-items-start.flex-shrink-0")
    |> Floki.find("strong.final-path")
    |> Floki.text()
  end

  @spec fetch_extension(String.t()) :: binary()
  def fetch_extension(html) do
    file_name =
      html
      |> Floki.parse_document!()
      |> Floki.find("div.repository-content")
      |> Floki.find("div.d-flex.flex-items-start.flex-shrink-0")
      |> Floki.find("strong.final-path")
      |> Floki.text()

    Path.extname(file_name)
  end

  @spec fetch_line_numbers(String.t()) :: integer()
  def fetch_line_numbers(html) do
    line_numbers_html =
      html
      |> Floki.parse_document!()
      |> Floki.find("div.text-mono.f6.flex-auto.pr-3")
      |> Floki.text()

    if line_numbers_html =~ ~r/sloc/ do
      line_numbers =
        Regex.scan(~r/(\d+) lines/, line_numbers_html)
        |> List.first()
        |> List.first()

      line_numbers =
        Regex.scan(~r/(\d+)/, line_numbers)
        |> List.first()
        |> List.first()

      {lines, _} = Integer.parse(line_numbers)
      lines
    else
      0
    end
  end

  @spec fetch_file_size_in_bytes(String.t()) :: float()
  def fetch_file_size_in_bytes(html) do
    string_bytes =
      html
      |> Floki.parse_document!()
      |> Floki.find("div.text-mono.f6.flex-auto.pr-3")
      |> Floki.text()

    cond do
      string_bytes =~ ~r/KB/ ->
        file_size_in_KB =
          Regex.scan(~r/(\d+)?.?(\d+)/, string_bytes)
          |> List.last()
          |> List.last()
          |> String.trim()

        {file_size_in_bytes, _} = Float.parse(file_size_in_KB)
        file_size_in_bytes * 1000.0

      string_bytes =~ ~r/MB/ ->
        file_size_in_MB =
          Regex.scan(~r/(\d+)?.?(\d+)/, string_bytes)
          |> List.last()
          |> List.last()
          |> String.trim()

        {file_size_in_bytes, _} = Float.parse(file_size_in_MB)
        file_size_in_bytes * 1_000_000.0

      string_bytes =~ ~r/Bytes/ ->
        file_size_in_bytes =
          Regex.scan(~r/(\d+)/, string_bytes)
          |> List.last()
          |> List.last()
          |> String.trim()

        {file_size_in_bytes, _} = Float.parse(file_size_in_bytes)
        file_size_in_bytes
    end
  end
end
