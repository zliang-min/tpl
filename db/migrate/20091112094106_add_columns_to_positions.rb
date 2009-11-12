class AddColumnsToPositions < ActiveRecord::Migration
  def self.up
    change_table :positions do |t|
      t.date :birthday
      t.string :education
      t.
    end
  end

  def self.down
  end
end
