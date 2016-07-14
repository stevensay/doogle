class CreateDefinitions < ActiveRecord::Migration
  def change
    create_table :definitions do |t|
      t.text :text
      t.references :entry, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
