require './config/environment'

class ApplicationController < Sinatra::Base
  extend Helper
  include Helper

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'secret'
  end

  get '/' do
    if logged_in?
      redirect to "/menu/#{session[:id]}" ##proper user interface
    else
      erb :index
    end
  end
end
