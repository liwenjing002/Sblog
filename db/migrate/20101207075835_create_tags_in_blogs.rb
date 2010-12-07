class CreateTagsInBlogs < ActiveRecord::Migration
  def self.up
    create_table :tags_in_blogs do |t|
      t.column :blog_id, :int
      t.column :tag_id, :int
      t.timestamps
    end
  end

  def self.down
    drop_table :tags_in_blogs
  end
end
