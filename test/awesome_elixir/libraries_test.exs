defmodule AwesomeElixirLibrariesTest do
  use ExUnit.Case

  test "parses markdown" do
    libraries =
      File.read!("test/awesome_elixir/awesome_readme_copy.md")
      |> AwesomeElixir.Libraries.parse_libraries()

    first = libraries |> List.first()
    %{title: "dflow", link: "https://github.com/dalmatinerdb/dflow", category: "Actors"} = first

    last = libraries |> Enum.reverse() |> List.first()
    %{title: "yomel", link: "https://github.com/Joe-noh/yomel", category: "YAML"} = last
  end
end
