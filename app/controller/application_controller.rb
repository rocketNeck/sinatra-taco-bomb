require './config/environment'
class ApplicationController < Sinatra::Base
  include FileUtils::Verbose
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/' do
    if logged_in?
      redirect to '/tweets'
    else
      erb :index
    end
  end
end
