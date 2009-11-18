class CreateConfigurations < ActiveRecord::Migration
  def self.up
    create_table :configurations do |t|
      t.string :name
      t.string :type
    end

    add_index :configurations, [:name, :type]
  end

  def self.down
    drop_table :configurations
  end
end
