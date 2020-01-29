class AddDetailsToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :title, :string
    add_column :posts, :started_at, :string
    add_column :posts, :finish_at, :string
  end
end
