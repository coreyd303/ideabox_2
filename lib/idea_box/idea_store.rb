require 'yaml/store'

class IdeaStore

  def self.create(attributes)
    idea = Idea.create(attributes)
    database.transaction do
      database['ideas'] << idea.to_h

    end
  end

  def self.database
    return @database if @database

    @database = YAML::Store.new('db/ideabox')
    @database.transaction do
      @database['ideas'] ||= []
    end
    @database
  end

  # is a pattern (trickier, b/c it requires chaining and going through an enumerator)
  # I want to put the results of my data merge into an array
  def self.all
    ideas = []
    raw_ideas.each_with_index do |data, i|
      ideas << Idea.new(data.merge("id" => i))
    end
    ideas
  end

  def self.raw_ideas
    database.transaction do |db|
      db['ideas'] || []
    end
  end

  def self.find(id)
    raw_idea = find_raw_idea(id)
    Idea.new(raw_idea.merge("id" => id))
  end

  def self.find_raw_idea(id)
    database.transaction do
      database['ideas'].at(id)
    end
  end

  def self.update(id, data)
    database.transaction do
      database['ideas'][id] = data
    end
  end

  def self.delete(position)
    database.transaction do
      database['ideas'].delete_at(position)
    end
  end

  def self.tag
    tag = all.collect(&:tag)
    tag.flatten.uniq!.sort
  end

  # tag_to_idea
  def self.all_by_tag
    ideas = {}
    tag.each.flat_map { |tag| ideas[tag] = find_by_tag(tag) }
    ideas
  end

  def self.find_by_tag(tag)
    all.find_all { |idea| idea.tag.include? (tag) }
  end

  def self.save_user_file(user_file)
   upload = File.new("public/#{Time.now}_#{File.basename(user_file[:filename])}", "w") 
   upload.write(user_file[:tempfile].read)
   upload.path
  end

  def self.find_user_file(user_file)
    
  end
end