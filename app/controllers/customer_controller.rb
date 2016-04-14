class CustomerController < ApplicationController
  ############################################################ customers

  ###### customer sing up flow #####

  get '/customers/signup' do #linked here from welcome page
    if !logged_in?
      erb :'/customers/signup'
    else
      redirect to "/menu/#{current_customer.id}"
    end
  end

  post '/signup' do
    customer = Customer.find_or_create_by(
      name: params[:name],
      email: params[:email],
      password_digest: params[:password_digest],
      city: params[:city],
      payment_info: params[:payment_info]
    )
    session[:id] = customer.id
    owner = Owner.find_by(city: params[:city])
    order = Order.create(total: 0,address: "not defined",customer: current_customer,status: "pending",owner: owner)
    redirect to "/customers/menu/#{customer.id}"
  end

############## customer log in ######################
  get '/customers/login' do #linked here from welcome page
    if !logged_in?
      erb :'/customers/login'
    else
      redirect to "/menu/#{current_customer.id}"
    end
  end

  post '/customers' do
    customer = Customer.find_by_email(params[:email])
    if customer.password_digest == params[:password_digest]
      session[:id] = customer.id
      redirect to "/customers/menu/#{customer.id}"
    else
      redirect to "/customers/login"
    end
  end

######### customer controll flow ############

# menu page
  get '/customers/menu/:id' do
    if logged_in?
      @menu_items = MenuItem.all############### would have to be changed to represent only the MenuItems of the owner for the current customer
      if current_order.status  != "pending"
        owner = Owner.find_by(city: current_customer.city)
        @order = Order.create(total: 0,address: "not defined",customer: current_customer,status: "start",owner: owner)#### needs feature to add address check based on location OR input
        erb :'/customers/menu'
      else
        @order = current_order
        erb :'/customers/menu'
      end
    else
      redirect to "/customers/login"
    end
  end

#clear order
  post '/reset' do   ### reset order ### need to build feature!
    if logged_in?
      current_order.reset
      redirect to "/menu/#{current_customer.id}"
    else
      redirect to "/customers/login"
    end
  end

# add item to order###################################
  post '/add_menu_item' do ### add menu item to order
    if logged_in?
      current_order.add_menu_item(params[:menu_item_id])
      redirect to "/customers/menu/#{current_customer.id}"
    else
      redirect to "/customers/login"
    end
  end

#go to show order and confirm
  post '/menu/:id/place_order' do
    if logged_in?
      @order = current_order
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
      current_order.status = "open"
      current_order.address = params[:address]
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
