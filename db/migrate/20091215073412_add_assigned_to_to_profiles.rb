class AddAssignedToToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.datetime :assigned_at
    end
  end

  def self.down
    change_table(:profiles) { |t| t.remove :assigned_at }
  end
end
