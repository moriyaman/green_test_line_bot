require 'active_record'
require 'mysql2'
require "sinatra"
require "json"
require 'rest-client'

ActiveRecord::Base.configurations = YAML.load_file('database.yml')
ActiveRecord::Base.establish_connection('development')

get "/callback" do
end

