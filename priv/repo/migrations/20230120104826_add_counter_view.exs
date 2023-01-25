defmodule Retention.Repo.Migrations.AddCounterView do
  use Ecto.Migration

  def change do
    create table(:counters, primary_key: false) do
      add(:counter_id, :string, primary_key: true)
      add(:value, :integer)
      timestamps(type: :utc_datetime)
    end
  end
end
