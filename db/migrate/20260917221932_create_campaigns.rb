class CreateCampaigns < ActiveRecord::Migration[8.1]
  def change
    create_table :campaigns do |t|
      t.string :name, null: false
      t.string :name_en
      t.string :locality
      t.string :province
      t.decimal :lat, precision: 9, scale: 6
      t.decimal :lng, precision: 9, scale: 6
      t.date :date
      t.integer :days
      t.text :description
      t.text :description_en

      t.timestamps
    end

    add_index :campaigns, :date
  end
end
