class CreatePublications < ActiveRecord::Migration[8.1]
  def change
    create_table :publications do |t|
      t.string :title, null: false
      t.string :title_en
      t.string :authors
      t.integer :year
      t.string :journal
      t.string :doi
      t.string :kind, null: false, default: "cientifica"

      t.timestamps
    end

    add_index :publications, :doi, unique: true
    add_index :publications, :kind
    add_index :publications, :year
  end
end
