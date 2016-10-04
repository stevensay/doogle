class AddWordIndexToEntriesTable < ActiveRecord::Migration
  def change
    add_index :entries, :word, unique: true
  end
end
