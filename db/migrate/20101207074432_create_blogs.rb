class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|

      t.column :title, :string,:null => false
      t.column :text, :text,:null => false
      t.column :users_id, :int,:null => false
      t.column :blog_type, :string,:null => false
      t.column :replay_count, :int,:default => 0
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end
