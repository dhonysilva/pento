defmodule Pento.Survey.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Catalog.Product
  alias Pento.Accounts.User

  schema "ratings" do
    field :starts, :integer
    belongs_to :user, User
    belongs_to :product, Product

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:starts, :user_id, :product_id])
    |> validate_required([:starts, :user_id, :product_id])
    |> validate_inclusion(:starts, 1..5)
    |> unique_constraint(:product_id, name: :index_ratings_on_user_product)
  end
end
