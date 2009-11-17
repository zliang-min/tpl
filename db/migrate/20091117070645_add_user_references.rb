class AddUserReferences < ActiveRecord::Migration
  AFFECTED_TABLES = [:positions, :profile_logs, :operations].freeze
  def self.up
    AFFECTED_TABLES.each { |table|
      change_table table do |t|
        t.references :user
      end
    }
  end

  def self.down
    AFFECTED_TABLES.each { |table|
      change_table table do |t|
        t.remove :user_id
      end
    }
  end
end
