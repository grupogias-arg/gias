class CreateMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :members do |t|
      t.string :name, null: false
      # rank es texto libre (Investigador/a, Posdoc, Becario/a doctoral, Pasante).
      t.string :rank
      t.string :rank_en
      t.text :focus
      t.text :focus_en
      t.text :bio
      t.text :bio_en
      t.string :email
      t.string :conicet_url
      t.string :researchgate_url
      t.integer :position, null: false, default: 0
      t.string :sede

      t.timestamps
    end

    add_index :members, :position
  end
end
