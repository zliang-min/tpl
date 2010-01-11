class CreateResumes < ActiveRecord::Migration
  def self.up
    create_table :resumes do |t|
      t.string   :file_file_name
      t.string   :file_content_type
      t.integer  :file_file_size
      t.datetime :file_file_updated_at

      t.belongs_to :profile
    end

    add_index :resumes, :profile_id
  end

  def self.down
    drop_table :resumes
  end
end
