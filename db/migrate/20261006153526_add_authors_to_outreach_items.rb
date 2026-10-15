class AddAuthorsToOutreachItems < ActiveRecord::Migration[8.1]
  def change
    add_column :outreach_items, :authors, :string
  end
end
