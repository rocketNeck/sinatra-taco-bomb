ENV['SINATRA_ENV'] ||= "development"
require 'bundler/setup'

Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'

# ActiveRecord::Base.establish_connection(
#   :adapter => "sqlite3",
#   :database => "db/#{ENV['SINATRA_ENV']}.sqlite"
# )

configure :development do
  set :datavase, "sqlite3:db/#{ENV['SINATRA_ENV']}.db"
end