#require 'active_record'
#require 'mysql2'
require "sinatra"
require "json"
require 'rest-client'
require "sinatra/reloader" if development?

#ActiveRecord::Base.configurations = YAML.load_file('database.yml')
#ActiveRecord::Base.establish_connection('development')

get "/" do
  "Hello, world!"
end

get "/callback" do
end

post "/linebot/callback" do
  line_mes = JSON.parse(request.body.read)["result"][0]
  message = line_mes["content"]["text"]
  contents = {
    contentType: 1,
    toType: 1,
    text: message
  }
  post_params = {
    to: [line_mes["content"]["from"]],
    toChannel: 1383378250,
    eventType: 138311608800106203,
    content: contents
  }
  headers = {
    "Content-Type": "application/json; charser=UTF-8",
    "X-Line-ChannelID": ENV["LINE_CHANNEL_ID"],
    "X-Line-ChannelSecret": ENV["LINE_CHANNEL_SECRET"],
    "X-Line-Trusted-User-With-ACL": ENV["LINE_CHANNEL_MID"]
  }

  RestClient.proxy = ENV["FIXIE_URL"]
  RestClient.post("https://trialbot-api.line.me/v1/events", post_params.to_json, headers)
end
