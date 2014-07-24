class Idea
  include Comparable

  attr_reader :title, :description, :tag, :rank, :id

  def self.create(attributes)
    attributes['tag'] = format_tag(attributes['tag'])
    new(attributes)
  end

  def self.format_tag(tag)
    tag.to_s.split(',').map(&:strip)
  end

  def initialize(attributes = {})
    @title       = attributes["title"]
    @description = attributes["description"]
    @tag         = attributes["tag"] || []
    @rank        = attributes["rank"] || 0
    @user_file   = IdeaStore.save_user_file(attributes["user_file"])
    @id          = attributes["id"]
  end
  #account for edit which will return user_file as a string...(when a hash save_user_file, as a string its most
    #likely a path so just use that)(conditonal)

  def user_file
    IdeaStore.find_user_file(@user_file)  
  end

  def save
    IdeaStore.create(to_h)
  end

  def to_h
    {
      "title"       => title,
      "description" => description,
      "tag"         => tag,
      "rank"        => rank,
      "user_file"   => @user_file
    }
  end

  def like!
    @rank += 1
  end

  def <=>(other)
    other.rank <=> rank
  end
end