defmodule AwesomeElixirWeb.PageController do
  use AwesomeElixirWeb, :controller

  def index(conn, _params) do
    libraries =
      AwesomeElixir.Libraries.get!()
      |> Enum.group_by(&(&1.category), &({&1.title, &1.url}))
      |> Enum.sort()

    render(conn, "index.html", libraries: libraries)
  end
end
