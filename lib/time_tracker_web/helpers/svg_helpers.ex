defmodule TimeTrackerWeb.SVGHelpers do
  import Phoenix.HTML

  def inline_svg(name) do
    path = Path.join(:code.priv_dir(:time_tracker), "static/images/#{name}.svg")

    case File.read(path) do
      {:ok, content} -> raw(content)
      {:error, _} -> raise "SVG file #{name}.svg not found"
    end
  end
end
