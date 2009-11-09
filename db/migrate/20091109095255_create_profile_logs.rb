class CreateProfileLogs < ActiveRecord::Migration
  def self.up
    create_table :profile_logs do |t|
      t.string :action, :null => false

      t.references :profile

      t.timestamps
    end

    add_index :profile_logs, :profile_id
  end

  def self.down
    drop_table :profile_logs
  end
end
