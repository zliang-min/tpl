class AddJdToPositions < ActiveRecord::Migration
  def self.up
    change_table :positions do |t|
      t.string :jd_file_name
      t.string :jd_content_type
      t.integer :jd_file_size
      t.datetime :jd_file_updated_at
    end
  end

  def self.down
    change_table :positions do |t|
      t.remove :jd_file_updated_at
      t.remove :jd_file_size
      t.remove :jd_content_type
      t.remove :jd_file_name
    end
  end
end
