#require 'active_record'
#require 'mysql2'
require "sinatra"
require "json"
require 'rest-client'
require 'line/bot'
#require "sinatra/reloader" if development?

#ActiveRecord::Base.configurations = YAML.load_file('database.yml')
#ActiveRecord::Base.establish_connection('development')

def client
  @client ||= Line::Bot::Client.new { |config|
    config.channel_id = ENV["LINE_CHANNEL_ID"]
    config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
    config.channel_mid = ENV["LINE_CHANNEL_MID"]
  }
end

get "/" do
  "Hello, world!"
end

post "/linebot/callback" do
  signature = request.env['HTTP_X_LINE_CHANNELSIGNATURE']
  unless client.validate_signature(request.body.read, signature)
    return "NO"
  end

  request = Line::Bot::Receive::Request.new(request.env)
  request.data.each { |message|
    case message
    when Line::Bot::Receive::Message
      case message.content
      when Line::Bot::Message::Text
        result = client.send_text(
          to_mid: message.from_mid,
          text: message.content[:text],
        )
      when Line::Bot::Message::Image, Line::Bot::Message::Video
      end
    when Line::Bot::Receive::Operation
    end
  }
  "OK"
end

=begin
post "/linebot/callback" do
  line_mes = JSON.parse(request.body.read)["result"][0]
  message = line_mes["content"]["text"]
  contents = {
    contentType: 1,
    toType: 1,
    text: "#{ message }\r\n求人ならここが良いわよ。http://www.green-japan.com/job/10154"
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
=end
