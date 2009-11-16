class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.authenticatable
      #t.confirmable
      #t.recoverable
      t.rememberable

      t.timestamps
    end

    add_index :users, :email
    #add_index :users, :confirmation_token
    #add_index :users, :reset_password_token
  end

  def self.down
    drop_table :users
  end
end
