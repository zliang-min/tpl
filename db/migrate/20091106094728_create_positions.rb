class CreatePositions < ActiveRecord::Migration
  def self.up
    create_table :positions do |t|
      t.string :name, null: false
      t.string :description
      t.integer :need, default: 0
      t.integer :filled, default: 0

      t.referneces :category, foreign_key: {dependent: :destroy}

      t.timestamps
    end

    add_index :positions, :name
  end

  def self.down
    drop_table :positions
  end
end
