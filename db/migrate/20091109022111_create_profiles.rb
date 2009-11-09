class CreateProfiles < ActiveRecord::Migration
  def self.up
    create_table :profiles do |t|
      t.string :name, :null => false
      t.string :state

      t.references :position

      t.timestamps
    end

    add_index :profiles, :position_id
  end

  def self.down
    drop_table :profiles
  end
end
