defmodule PentoWeb.RatingLive.Show do
  use Phoenix.Component
  import Phoenix.HTML

  attr :rating, :any, required: true

  def stars(assigns) do
    ~H"""
    <div>
      <%= @rating.starts
      |> filled_stars()
      |> Enum.concat(unfilled_stars(@rating.starts))
      |> Enum.join(" ")
      |> raw() %>
    </div>
    """
  end

  def filled_stars(starts) do
    List.duplicate("&#x2605;", starts)
  end

  def unfilled_stars(starts) do
    List.duplicate("&#x2606;", 5 - starts)
  end
end
