class Blog < ActiveRecord::Base
#  has_many :tag,:finder_sql =>"select tags.* from tags,tags_in_blogs,blogs \
#  where tags_in_blogs.blog_id =blogs.id and tags_in_blogs.blog_id = tags.id"
  belongs_to :user,:foreign_key => "owner_id"
end
