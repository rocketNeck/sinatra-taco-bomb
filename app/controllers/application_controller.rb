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
  end ## to be sure you don't go to the login or sign up if you are already logged in



####### admin log in flow #######
  get '/admin' do
    erb :'/admin/login'
  end
  ### chicken or the egg? the first admin is me and only i can create new admins directly at the database
  post '/admin/login' do
     @admin = Admin.find_by(params)
     if @admin && @admin.authenticate(params[:password])
       session[:id] = @admin.id
       redirect to "/admin/admin_dashboard"
     else
       redirect to "/admin"
     end
  end
###### admin contorll flow #####











############ owner sales page ########
get '/owners' do       #####link here from franchise opritunities link on home page
  ##this sales page should also have contact and email to submit to parent company
  erb :'/owners/welcome'
end

###### owner log in flow #######3


  get '/owners/login' do  #link here from owners welcome sales page
    if logged_in?
      redirect to "/owners/#{current_user.slug}"
    else
      erb :'/owners/login'
    end
  end

  post '/owners/login' do
    if !logged_in?
      @owner = Owner.find_by(email: params[:email]).authenticate(params[:password])
      session[:id] = @owner.id
      redirect to "/owners/#{@owner.id}"
    else
      redirect to "/owners/login"
    end
  end


  get '/owners/:id' do
    if logged_in?
      @owner = current_user
      @oders = Orders.all
###################################################### this is where you left off!!!!!!!!!
    else
      redirect to "/owners/login"
    end

  ## get pending orders and list them
  ## can see a list of pending orders
  ## can complete an order (mark finished)
  ## can see links to create new menu item
  ## can see link to edit a menu item
  #
  end



###### customer sing up flow #####
  #when a customer is created he must open an order and get assigned an owner
  #link from welcome page links here
  get '/customers/signup' do
    if !logged_in?
      erb :'/customers/signup'
    else
      redirect to "/menu/#{session[:id]}"
    end
  end
  post '/customers/singup' do ######be sure to check to make sure the params aren't empty
    @customer = Customer.create(params[:customer])
    @owner = Owner.find_by(params[:city])
    @order = Order.create(total: 0, owner_id: @owner.id, customer_id: @customer.id)
    @customer.orders <<  @order
    session[:id] = @customer.id
    redirect to "/menu/#{@customer.id}"
  end

############## customer log in ######################
  get '/customers/login' do#linked here from welcome page
    if !logged_in?
      erb :'/customers/login'
    else
      redirect to "/menu/#{session[:id]}"
    end
  end
  post '/customers/login' do
    @customer = Customer.find_by(params)
    ## check to see if customer is valid then render customers menu
    if @customer && @customer.authenticate(params[:password])
      session[:id] == @customer.id
      redirect to "/menu/#{@customer.id}"
    else
      redirect to "/customers/login"
    end
  end

######### customer controll flow ############
  get '/menu/:id' do
    if logged_in?
      @customer = current_user
      @menu_items = MenuItem.all
      @order = Order.create(total: 0)
      @customer.orders << @order
      erb :'/customers/menu'
    else
      redirect to "/customers/login"
    end
  end

  post '/menu/:id' do
    ### form or input to add decriment one preped menu_item and add price of menu_item to order.total
  end

  get '/logout' do
    if logged_in?  ##this should be a button i think
      session.clear
      redirect to "/"
    end
  end
end
