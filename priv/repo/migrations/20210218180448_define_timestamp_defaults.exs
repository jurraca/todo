defmodule Todo.Repo.Migrations.DefineTimestampDefaults do
  use Ecto.Migration
  import Ecto.Query

  def change do
    alter table("tasks") do
      modify :inserted_at, :utc_datetime, default: fragment("NOW()")
      modify :updated_at, :utc_datetime, default: fragment("NOW()")
    end
  end
end
