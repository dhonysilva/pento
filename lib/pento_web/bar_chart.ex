defmodule PentoWeb.BarChart do
  alias Contex.Dataset
  alias Contex.BarChart
  alias Contex.Plot

  def make_bar_chart_dataset(data) do
    Dataset.new(data)
  end

  def make_bar_chart(dataset) do
    dataset
    |> BarChart.new()
  end

  defp chart_helpers do
    quote do
      import PentoWeb.BarChart
    end
  end

  def chart_live do
    quote do
      unquote(chart_helpers())
    end
  end

  def render_bar_chart(chart, title, subtitle, x_axis, y_axis) do
    Plot.new(800, 400, chart)
    |> Plot.titles(title, subtitle)
    |> Plot.axis_labels(x_axis, y_axis)
    |> Plot.to_svg()
  end
end
