class Blog < ActiveRecord::Base
  has_many :tag,:finder_sql =>"select tags.* from tags,tags_in_blogs,blogs
  where tags_in_blogs.blog_id =blogs.id and tags_in_blogs.tag_id = tags.id"
  belongs_to :user,:foreign_key => "owner_id"

  validates_presence_of :title,:message => "标题不为空"
  validates_presence_of :text,:message => "正文不为空"

  attr_accessor :blog_tags
  
  def before_create
    if self.blog_tags != '' and self.blog_tags !=nil
      tags = self.blog_tags.split(/,/)
      if tags.length ==0
        errors.add(:blog_tags, "标签分隔出错，请检查")
      end
    end
  end

  def after_create
    tags = self.blog_tags.split(/,/)
    tags.each{|tag_text|
      tag = Tag.find_by_text(tag_text)
      tag = Tag.new({:text=>tag_text}) if tag==nil
      TagsInBlog.new({:blog_id=>self.id,:tag_id=>tag.id})
    }
  end
end