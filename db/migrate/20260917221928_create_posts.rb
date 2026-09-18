class CreatePosts < ActiveRecord::Migration[8.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.string :title_en
      t.string :slug, null: false
      t.string :kind, null: false, default: "divulgacion"
      t.datetime :published_at
      t.text :excerpt
      t.text :excerpt_en

      t.timestamps
    end

    add_index :posts, :slug, unique: true
    add_index :posts, :kind
    add_index :posts, :published_at
  end
end
