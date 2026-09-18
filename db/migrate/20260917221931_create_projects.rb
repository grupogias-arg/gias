class CreateProjects < ActiveRecord::Migration[8.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.string :title_en
      t.string :funder, null: false, default: "otros"
      t.integer :year_start
      t.integer :year_end
      t.text :description
      t.text :description_en

      t.timestamps
    end

    add_index :projects, :funder
    add_index :projects, :year_start
  end
end
