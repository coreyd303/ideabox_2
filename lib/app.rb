require 'bundler'
Bundler.require
require 'idea_box'
require 'haml'
require 'simplecov'
Simplecov.start

class IdeaBoxApp < Sinatra::Base
  set :method_override, true
  set :root, 'lib/app'
  #set :public_folder, public 

  configure :development do
    register Sinatra::Reloader
  end

  not_found do
    erb :error
  end

  get '/' do
    erb :index, locals: {ideas: IdeaStore.all.sort, idea: Idea.new(params)}
  end

  post '/' do
    puts(params[:idea].inspect)
    IdeaStore.create(Idea.new(params[:idea]).to_h)
    redirect '/'
  end

  post '/:id/like' do |id|
    idea = IdeaStore.find(id.to_i)
    idea.like!
    IdeaStore.update(id.to_i, idea.to_h)
    redirect '/'
  end

  get '/:id/edit' do |id|
    idea = IdeaStore.find(id.to_i)
    erb :edit, locals: {idea: idea}
  end

  get '/:tag/tag' do |tag|
    erb :tag, locals: {ideas: IdeaStore.find_by_tag(tag)}
  end

  put '/:id' do |id|
    IdeaStore.update(id.to_i, params[:idea])
    redirect '/'
  end

  delete '/:id' do |id|
    IdeaStore.delete(id.to_i)
    redirect '/'
  end
end