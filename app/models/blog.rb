class Blog < ActiveRecord::Base



  has_many :tags_in_blog
  has_many :tag, :through => :tags_in_blog
  belongs_to :user,:foreign_key => "users_id"

  validates_presence_of :title,:message => "标题不为空"
  validates_presence_of :text,:message => "正文不为空"
  validates_presence_of :blog_type,:message => "分类不为空"

  validates_length_of :title, :maximum => 40,:message=>"标题太长，最多40个字"

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
      tag.save
      tagsInBlog = TagsInBlog.new({:blog_id=>self.id,:tag_id=>tag.id})
      tagsInBlog.save
    }
  end
end