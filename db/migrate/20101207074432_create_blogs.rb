class CreateBlogs < ActiveRecord::Migration
  def self.up
    create_table :blogs do |t|
      t.column :title, :string
      t.column :text, :string
      t.column :owner_id, :int
      t.column :blog_type, :string
      t.column :replay_count, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :blogs
  end
end