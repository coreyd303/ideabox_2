require 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require 'rack/test'

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    IdeaBoxApp.new
  end

  it 'is a box of creatable/editble/deletable ideas' do
    # go to index
    # see the form (instead of filling it out)
    # see that an idea doesn't exist
    # submit an idea
    # now an idea exists
    # edit the idea(a: find link then go there, b: just go where we think it is)
    # I should dee the form in the current values
    # submit the updated values
    # delete the idea
    skip
  end

  it 'likes ideas to get rank, this displays by order' do
  end


  it 'tags ideas, searches by tags for ideas' do
  end
    
end