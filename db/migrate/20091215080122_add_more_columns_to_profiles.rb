class AddMoreColumnsToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.string :chinese_name
      t.string :mobile_phone
      t.string :email
      t.string :channel
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :channel
      t.remove :email
      t.remove :mobile_phone
      t.remove :chinese_name
    end
  end
end
