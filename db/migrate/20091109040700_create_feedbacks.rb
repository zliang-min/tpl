class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.text :content

      t.references :profile_log

      t.timestamps
    end

    add_index :feedbacks, :profile_log_id
  end

  def self.down
    drop_table :feedbacks
  end
end
