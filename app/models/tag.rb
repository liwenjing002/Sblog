class Tag < ActiveRecord::Base
  has_many :tags_in_blog
  has_many :blog, :through => :tags_in_blog
end
