class AddAttachmentsToProfiles < ActiveRecord::Migration
  def self.up
    change_table :profiles do |t|
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_file_updated_at

      t.string :cv_file_name
      t.string :cv_content_type
      t.integer :cv_file_size
      t.datetime :cv_file_updated_at
    end
  end

  def self.down
    change_table :profiles do |t|
      t.remove :cv_file_updated_at
      t.remove :cv_file_size
      t.remove :cv_content_type
      t.remove :cv_file_name

      t.remove :picture_file_updated_at
      t.remove :picture_file_size
      t.remove :picture_content_type
      t.remove :picture_file_name
    end
  end
end
