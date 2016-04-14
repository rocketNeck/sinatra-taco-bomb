class OwnerController < ApplicationController
############ owner sales page ########
get '/owners/welcome' do       #####link here from franchise opritunities link on home page
  ##this sales page should also have contact and email to submit to parent company
  erb :'/owners/welcome'
end
##### owner log in flow #######
  get '/login' do  #link here from owners welcome sales page
    if logged_in?
      redirect to "/owners/#{current_owner.id}"
    else
      erb :'/owners/login'
    end
  end

  post '/owners' do
    if !logged_in?
      @owner = Owner.find_by_email(params[:email])
      if @owner && @owner.password_digest == params[:password_digest]
        session[:id] = @owner.id
        redirect to "/owners/#{current_owner.id}"
      else
        redirect to "/login"
      end
    else
      redirect to "/login"
    end
  end
#owner controlls######################
################################################ owners_dashboard
#render list of orders and links to other parts of the UI
  get '/owners/:id' do
    if logged_in?
      @owner = current_owner
      @orders = current_owner.orders.where(status: "open")
      erb :'/owners/owner_dashboard'
    else
      redirect to "/login"
    end
  end

# mark a order closed button
  patch '/owners/:id/close' do
    if logged_in?
      order = Order.find_by(id: params[:id])
      order.status = "closed"
      order.save
      redirect to "/owners/:id"
    else
      redirect to "/owners/login"
    end
  end
#####################################################
#render list of menu items
  get '/owners/:id/menu_items' do #link here form dashboard
    if logged_in?
      @menu_items = current_owner.menu_items.all
      erb :'/owners/menu_items'
    else
      redirect to "/owners/login"
    end
  end
###############################################################
#render an individual menu item
  get '/owners/:id/menu_item_show/:id' do
    if logged_in?
      @menu_item = current_owner.menu_items.find_by_id(params[:id])
      erb :'/owners/menu_item_show'
    else
      redirect to "/owners/login"
    end
  end

# add or subtract the amount of prepped for this menu item
  post '/add/:id' do
    if logged_in?
      MenuItem.find_by(id: params[:id]).add_to_prepped(params[:add].to_i)
      redirect to "/owners/#{current_owner.id}/menu_items"
    else
      redirect to "/owners/login"
    end
  end
  post '/sub/:id' do
    if logged_in?
      MenuItem.find_by(id: params[:id]).add_to_prepped(params[:subtract].to_i)
      redirect to "/owners/#{current_owner.id}/menu_items"
    else
      redirect to "/owners/login"
    end
  end
#delet this menu_item
  delete '/owners/menu_item_show/:id/delete' do
    if logged_in?
      menu_item = current_owner.menu_items.find_by(id: params[:id])
      menu_item.destroy
      redirect to "/owners/#{current_owner.id}/menu_items"
    else
      redirect to "/owners/login"
    end
  end

# render edit a menu item by id
  get '/owners/:id/edit_menu_item/:id' do
    if logged_in?
      @menu_item = MenuItem.find_by(id: params[:id])
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
      menu_item = current_owner.menu_items.find_by(id: params[:id])
      menu_item.name = params[:name]
      menu_item.price = params[:price]
      menu_item.img_path = params[:img_path]
      menu_item.current_number_prepped = params[:current_number_prepped]
      menu_item.save
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
  post '/create_new_menu_item' do
    if logged_in? && current_owner
      current_owner.menu_items.create(
      name: params[:name],
      price: params[:price].to_i,
      description: params[:description],
      img_path: params[:img_path],
      current_number_prepped: params[:current_number_prepped].to_i,
      owner_id: current_owner.id
      )
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
    if logged_in?
      @orders = Order.find_by_sql("SELECT orders.* WHERE status == 'closed' ORDER BY created_at DESC")
      erb :'/owners/orders_list'
    else
      redirect to "/owners/login"
    end
  end
end
