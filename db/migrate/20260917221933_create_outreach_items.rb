class CreateOutreachItems < ActiveRecord::Migration[8.1]
  def change
    create_table :outreach_items do |t|
      t.string :title, null: false
      t.string :title_en
      t.string :kind, null: false, default: "video"
      t.string :url
      t.string :youtube_id
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :outreach_items, :kind
    add_index :outreach_items, :position
  end
end
