class User < ActiveRecord::Base
  has_secure_password
  has_many :tweets

  def slug
    username.split(" ").collect{|part| part.downcase}.join("-")
  end

  def self.find_by_slug(slug)
    username = slug.split("-").collect{|part| part.capitalize}.join(" ")
    User.where("lower(username) = ?", username.downcase).first
  end
end
