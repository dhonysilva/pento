defmodule Pento.Accounts.Profile do
  use Ecto.Schema
  import Ecto.Changeset

  alias Pento.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "profiles" do
    field :username, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def registration_changeset(profile, attrs) do
    profile
    |> cast(attrs, [:username, :user_id])
    |> validate_required([:username])
  end
end
