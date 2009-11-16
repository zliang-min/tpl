class AddColumnsToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.date :birthday
      t.string :education
      t.integer :work_experience
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :work_experience
      t.remove :education
      t.remove :birthday
    end
  end
end
