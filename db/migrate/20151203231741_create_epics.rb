class CreateEpics < ActiveRecord::Migration
  def change
    create_table :epics do |t|
      t.string :title
      t.text :description
      t.integer :priority

      t.timestamps
    end
  end
end
