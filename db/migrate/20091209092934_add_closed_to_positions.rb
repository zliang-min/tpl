class AddClosedToPositions < ActiveRecord::Migration
  def self.up
    change_table :positions do |t|
      t.boolean :closed, :default => false
    end
  end

  def self.down
    change_table :positions do |t|
      t.remove :closed
    end
  end
end
