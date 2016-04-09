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
#render admin dashboard
  get '/admin/:id' do
    if logged_in?
      @owners = Owner.all
      erb :'/admin/admin_dashboard'
    else
      redirect to "/admin"
    end
  end

  get '/admin/owner_show' do
    if logged_in?
      @owner = Owner.find(id: perams[:id])
      erb :'/admin/show_owner'
    else
      redirect to "/admin"
    end
  end


################################create an owner
  get '/admin/owner_create' do
    if logged_in?
      erb :'/admin/create_owner'
    else
      redirect to "/admin"
    end
  end

  post '/admin/owner_create' do
    if logged_in?
      owner = Owner.create(params)
      redirect to "/admin/#{current_admin.id}"
    else
      redirect to "/admin/login"
    end
  end
################################
  get '/admin/owner_edit/:id' do
    if logged_in?
      @owner = Owner.find(id: params[:id])
      erb :'/admin/edit_owner'
    else
      redirect to "/admin"
    end
  end
  post '/admin/owner_edit/:id' do
    if logged_in?
      owner = Owner.find_by(id: params[:id])
      owner.update(params)
      redirect to "/admin/#{current_admin.id}"
    else
      redirect to "/admin"
    end
  end













############ owner sales page ########
get '/owners' do       #####link here from franchise opritunities link on home page
  ##this sales page should also have contact and email to submit to parent company
  erb :'/owners/welcome'
end
###### owner log in flow #######3


  get '/owners/login' do  #link here from owners welcome sales page
    if logged_in?
      redirect to "/owners/#{current_owner.id}"
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

#owner controlls######################


################################################ owners_dashboard
#render list of orders and links to other parts of the UI
  get '/owners/:id' do
    if logged_in? && current_owner
      @owner = current_owner
      @orders = Order.hanging
      erb :'/owners/owners_dashboard'
    else
      redirect to "/owners/login"
    end
  end

# mark a order closed button
  post '/owners/:id/closed' do
    if logged_in? && current_owner
      @order = Order.find(id: params[:id], owner_id: current_owner.id)
      @order.status = "closed"
      redirect to "/owners/:id"
    else
      redirect to "/owners/login"
    end
  end
#####################################################
#render list of menu items
  get '/owners/:id/menu_items' do #link here form dashboard
    if logged_in? && current_owner
      @menu_items = MenuItem.where(owner_id: current_owner.id)
      erb :'/owners/menu_items'
    else
      redirect to "/owners/login"
    end
  end
###############################################################
#render an individual menu item
  get '/owners/:id/menu_item_show/:id' do
    if logged_in? && current_owner
      @menu_item = MenuItem.find(id: params[:id])
      erb :'/owners/menu_item_show'
    else
      redirect to "/owners/login"
    end
  end

# add or subtract the amount of prepped for this menu item
  post '/owners/:id/menu_item_show/:id' do
    if logged_in? && current_owner
      menu_item = MenuItem.find(id: perams[:id])
      if params[:add]
        menu_item.add_to_prepped(params[:add])
      end
      if params[:sub]
        menu_item.subtract_from_prepped(params[:sub])
      end
      redirect to "/owners/#{current_owner.id}/menu_items"
    else
      redirect to "/owners/login"
    end
  end
#delet this menu_item
  post '/owners/:id/menu_item_show/:id/delete' do
    if logged_in? && current_owner
      menu_item = MenuItem.find(params[:id], owner_id: current_owner.id)
      if menu_item.owner_id == current_owner.id
        menu_item.destroy
      end
      redirect to "/owner/#{current_owner.id}/menu_items"
    else
      redirect to "/owner/login"
    end
  end
###############################################################
# render edit a menu item by id
  get '/owners/:id/edit_menu_item'
    if logged_in? && current_owner
      @menu_item = MenuItem.find_by(id: perams[:id])
      erb :'/owners/menu_items_edit'
    else
      redirect to "/owners/login"
    end
  end
# post edits / changes
  post '/owners/edit_menu_item' do
    if params[:description].empty?
      redirect to "/owners/#{current_owner.id}/edit_menu_item"
    end
    if logged_in? && current_owner
      menu_item = MenuItem.find(id: params[:id])
      menu_item.update(params)
      redirect to "/owners/#{current_owner.id}/menu_items"
    else
      redirect to "/owners/login"
    end
  end

################################################################
#render form to create_new_menu_item
  get '/owners/:id/create_new_menu_item' do #linked form menu items list
    if logged_in? && current_owner
      erb :'/owners/create_new_menu_item'
    else
      redirect to "/owners/login"
    end
  end

#submit form for creating a menu item
  post '/owners/create_new_menu_item' do
    if logged_in? && current_owner
      menu_item = MenuItem.create(params)
      current_owner.menu_items.push(menu_item)
      redirect to "/owners/#{current_owner.id}"
    else
      redirect to "/owners/login"
    end
  end
############################################################
  get '/owners/:id/customers' do
    if logged_in? && current_owner
      @customers = Customer.where(owner_id: current_owner.id)
      erb :'/owners/customers_list'
    else
      redirect to "/owners/login"
    end
  end

  get '/owners/:id/customer/:id' do
    if logged_in?
      @customer = Customer.find(id: params[:id])
      erb :'/owners/customer_show'
    else
      redirect to "/owners/login"
    end
  end
  ############################################################
#render old orders
  get '/owners/:id/orders' do
    if logged_id?
      @orders = Order.find_by_sql("SELECT orders.* WHERE status == "closed" ORDER BY created_at DESC")
      erb :'/owners/orders_list'
    else
      redirect to "/owners/login"
    end
  end

############################################################ customers

###### customer sing up flow #####

  get '/customers/signup' do#link from welcome page links here
    if !logged_in?
      erb :'/customers/signup'
    else
      redirect to "/menu/#{session[:id]}"
    end
  end
  post '/customers/singup' do ######be sure to check to make sure the params aren't empty
    customer = Customer.create(params[:customer])
    owner = Owner.find_by(params[:city])
    order = Order.create(total: 0, owner_id: owner.id, customer_id: customer.id)
    customer.orders <<  order
    session[:id] = customer.id
    redirect to "/menu/#{customer.id}"
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
    if @customer && @customer.authenticate(params[:password])
      session[:id] == @customer.id
      redirect to "/menu/#{@customer.id}"
    else
      redirect to "/customers/login"
    end
  end


######### customer controll flow ############

# menu page

#must render to show_order page  listing the menu items / button to submit order / button to go back to menu
  get '/menu/:id' do
    if logged_in?
      @customer = current_customer
      @menu_items = MenuItem.find_by_sql("SELECT menu_items.* WHERE current_number_prepped > 0 ORDER BY current_number_prepped DESC")
      @order = current_order
      erb :'/customers/menu'
    else
      redirect to "/customers/login"
    end
  end

#clear order
  post '/menu/:id/reset' do   ### reset order
    if logged_in?
      current_order.reset
      redirect to "/menu/#{current_customer.id}"
    else
      redirect to "/customers/login"
    end
  end

# add item to order
  post '/menu/:id/add' do ### add menu item to order
    if logged_in?
      current_order.add_menu_item(perams[:menu_item][:id]) #needs to be the {:id => 17} here
      redirect to "/menu/#{current_customer.id}"
    else
      redirect to "/customers/login"
    end
  end

#go to show order and confirm
  post '/menu/:id/place_order' do
    if logged_in?
      redirect to "/customers/#{current_customer.id}/show_order"
    else
      redirect to "/customers/login"
    end
  end


#show order and confirm
  get '/customers/:id/show_order' do
    if logged_in?
      @customer = current_customer
      @order = current_order
      @items = @order.menu_items.all
      erb :'/customers/show_order'
    else
      redirect to "/customers/login"
    end
  end

#submit order button
  post '/customers/submit' do
    if logged_in?
      current_order.status = "hanging"
      current_order.save
      redirect to "/thank_you"
    else
      redirect to "/customers/login"
    end
  end

#get more button
  post '/edit' do #### from order page to menu with no changes
    if logged_in? && current_order.status == "pending"
      redirect to "/menu/#{current_customer.id}"
    else
      redirect to "/customers/login"
    end
  end

#show thank you page
 get '/thank_you' do
   if logged_in?
     session.clear
     erb :'/customers/desplay_thank_you'
   else
     redirect to "/customers/login"
   end
 end

#log out
  get '/logout' do #set log out from meny page  logging out before finalizing the order must revert the state of the objects
    if logged_in?  ##this should be a button i think
      session.clear
      redirect to "/"
    else
      redirect to "/customers/login"
    end
  end

end
