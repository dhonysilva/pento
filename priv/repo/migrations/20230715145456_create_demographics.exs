defmodule Pento.Repo.Migrations.CreateDemographics do
  use Ecto.Migration

  def change do
    create table(:demographics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :gender, :string
      add :year_of_birth, :integer
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create unique_index(:demographics, [:user_id])
  end
end
