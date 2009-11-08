class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.string :name, null: false
      t.string :description, limit: 1000
    end

    add_index :categories, :name, :unique => true
  end

  def self.down
    drop_table :categories
  end
end
