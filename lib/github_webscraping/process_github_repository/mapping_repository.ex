defmodule GithubWebscraping.ProcessGithubRepository.MappingRepository do
  alias GithubWebscraping.Constants

  def process(url) do
    IO.puts(Constants.git_url_base())
    IO.puts(url)
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
