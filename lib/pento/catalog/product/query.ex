defmodule Pento.Catalog.Product.Query do
  import Ecto.Query
  alias Pento.Catalog.Product
  alias Pento.Survey.Rating
  alias Pento.Survey.Demographic
  alias Pento.Accounts.User

  def base, do: Product

  def with_user_ratings(user) do
    base()
    |> preload_user_ratings(user)
  end

  def preload_user_ratings(query, user) do
    ratings_query = Rating.Query.preload_user(user)

    query
    |> preload(ratings: ^ratings_query)
  end

  def with_average_ratings(query \\ base()) do
    query
    |> join_ratings
    |> average_ratings
  end

  def join_ratings(query) do
    query
    |> join(:inner, [p], r in Rating, on: r.product_id == p.id)
  end

  def average_ratings(query) do
    query
    |> group_by([p], p.id)
    |> select([p, r], {p.name, avg(r.starts)})
    |> order_by([p, r], [{:asc, p.name}])
  end
end
