class AddAssignToAndCvToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.string :assign_to
      t.text   :cv
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :assign_to
      t.remove :cv
    end
  end
end
