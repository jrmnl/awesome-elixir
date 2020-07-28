defmodule AwesomeElixir.Libraries do
  alias EarmarkParser.Block

  @readme_url "https://raw.githubusercontent.com/h4cc/awesome-elixir/master/README.md"

  @spec get! :: [%{title: String.t(), link: String.t(), category: String.t()}]
  def get!() do
    %{body: body} = HTTPoison.get!(@readme_url)
    parse_libraries(body)
  end

  @spec parse_libraries(String.t()) :: [
          %{title: String.t(), link: String.t(), category: String.t()}
        ]
  def parse_libraries(readme) do
    {blocks, _links, _options} =
      readme
      |> String.split(~r{\r\n?|\n})
      |> EarmarkParser.Parser.parse()

    blocks
    |> skip_to_content()
    |> extract_libraries()
  end

  defp skip_to_content(readme_blocks) do
    [
      _heading,
      _introduction,
      _plusone,
      _other_curated_lists,
      _table_of_content
      | content
    ] = readme_blocks

    content
  end

  defp extract_libraries([
         _category_header = %Block.Heading{content: category},
         _description,
         _libs_list = %Block.List{blocks: libraries}
         | tail
       ]) do
    libs =
      for lib_block <- libraries do
        %Block.ListItem{blocks: [text_block]} = lib_block
        %Block.Text{line: [lib_info]} = text_block
        [_, title, link] = Regex.run(~r/\[(.+?)\]\((.+?)\)/, lib_info)
        %{title: title, link: link, category: category}
      end

    libs ++ extract_libraries(tail)
  end

  defp extract_libraries(_), do: []
end
