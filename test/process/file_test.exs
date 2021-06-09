defmodule Process.FileTest do
  use ExUnit.Case, async: true
  alias GithubWebscraping.Process.ExtractFileInfos

  describe "extract informations from file" do
    test "fetch_file_name/1" do
      file = File.read!("test/support/assets/file_example.html")

      file_name = ExtractFileInfos.fetch_file_name(file)

      assert file_name == "polyfills.ts"
    end
  end
end
