require 'rubygems'
require 'sinatra'
require 'json'
require 'pp'

configure do
  set :logging, true
  set :dump_errors, true
  set :public_folder, Proc.new { File.expand_path(File.join(root, 'Fixtures')) }
end

def render_fixture(filename)
  send_file File.join(settings.public_folder, filename)
end

# Creates a route that will match /articles/<category name>/<article ID>
get '/messages' do
  render_fixture('messages.json')
end

get '/conversations' do
  #sleep 1.5;
  render_fixture('conversations.json')
end
