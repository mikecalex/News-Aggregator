require "sinatra"
require "sinatra/reloader"
require 'pry'
require 'csv'
require 'uri'
# require_relative "models/player"
# require_relative "models/team"
# require_relative "models/team_data"

set :bind, '0.0.0.0'  # bind to all interfaces

get "/" do
  redirect "/articles"
end

get "/articles" do
  @articles = []
  CSV.foreach("articles.csv", headers:true) do |row|
    @articles << row.to_h
  end
  erb :"/articles"
end

get "/articles/new" do
  erb :new
end

post "/articles/new" do
  @title = params["article_title"]
  @description = params["article_description"]
  @url = params["article_url"]

  @error = nil
  if [@title, @description, @url].include?('')
    @error = "Please fill in all the fields!!!"
    erb :"/new"
  else
    CSV.open("articles.csv", "a", headers: true) do |csv|
      csv << [@title, @description, @url]
    end
    redirect "articles"
  end
end
