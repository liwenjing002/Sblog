class Blog < ActiveRecord::Base



  has_many :tags_in_blog
  has_many :tag, :through => :tags_in_blog
  belongs_to :user,:foreign_key => "users_id"

  validates_presence_of :title,:message => "标题不为空"
  validates_presence_of :text,:message => "正文不为空"
  validates_presence_of :blog_type,:message => "分类不为空"

  validates_length_of :title, :maximum => 40,:message=>"标题太长，最多40个字"

  attr_accessor :blog_tags

  after_create :split_tags
  after_save :split_tags
  

  def validate
    if self.blog_tags != '' and self.blog_tags !=nil
      tags = self.blog_tags.split(/,/)
      if tags.length ==0
        errors.add(:blog_tags, "标签分隔出错，请检查")
        elsif tags.length>8
          errors.add(:blog_tags, "标签最多为8个")
      end
      tags.each{|tag|
        temp = tag.split(//)
        chinese_num = 0
        temp.each{|c|
          chinese_num +=1 if c.length>1
        }#判断中文个数比较山寨，暂时先用用
        errors.add(:blog_tags, "单个标签长度最长5个汉字或15个字母") if chinese_num>5 or tag.length>15
        return
      }

    end
  end

  def split_tags
    tags = self.blog_tags.split(/,/)
    TagsInBlog.find_by_sql("delete from tags_in_blogs where blog_id =#{self.id}") #比较山寨
    tags.each{|tag_text|
      tag = Tag.find_by_text(tag_text)
      if tag==nil
        tag = Tag.new({:text=>tag_text}) 
        tag.save
      end
#      tagsInBlog = TagsInBlog.find_by_blog_id_and_tag_id(self.id,tag.id)
#      if tagsInBlog==nil
        tagsInBlog = TagsInBlog.new({:blog_id=>self.id,:tag_id=>tag.id})
        tagsInBlog.save!
#      end
    }
  end
end