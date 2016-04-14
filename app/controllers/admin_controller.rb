class AdminController < ApplicationController
  ####### admin log in flow #######
  get '/admin' do
    erb :'/admin/login'
  end
  ### chicken or the egg? the first admin is me and only i can create new admins directly at the database
  post '/admin/login' do
     @admin = Admin.find_by_email(params[:email])
     if @admin && @admin.password_digest == params[:password_digest]
       session[:id] = @admin.id
       redirect to "/admin/#{current_admin.id}"
     else
       redirect to "/admin"
     end
  end
###### admin contorll flow #####
#render admin dashboard
  get '/admin/:id' do
    if logged_in?
      @admin = current_admin
      @owners = Owner.all
      erb :'/admin/admin_dashboard'
    else
      redirect to "/admin"
    end
  end

  get '/owner/:id' do
    if logged_in?
      @owner = Owner.find_by_id(params[:id])
      @customers = @owner.customers.all
     erb :"/admin/show_owner"
    else
      redirect to '/admin'
    end
  end

################################create an owner
  get '/owner_create' do
    if logged_in?
      erb :'/admin/create_owner'
    else
      redirect to "/admin"
    end
  end

  post '/owner_create' do
    if logged_in?
      owner = Owner.create(params)
      owner.admin_id = current_admin.id
      redirect to "/admin/#{current_admin.id}"
    else
      redirect to "/admin/login"
    end
  end
  ## working with the idea of uploading files to my public/img file
  # if params[:file]
  #   filename = params[:file][:filename]
  #   tempfile = params[:file][:tempfile]
  #   target = "public/img/#{filename}"
  #   File.open(target, 'wb') {|f| f.write tempfile.read }
  #owner.img_path = "public/img/#{filename}"
  # end

################################ edit owner
  get '/edit_owner/:id' do
    if logged_in?
      @owner = Owner.find_by_id(params[:id])
      erb :'/admin/edit_owner'
    else
      redirect to "/admin"
    end
  end

  post '/edit_owner/:id' do
    if logged_in?
      owner = Owner.find_by_id(params[:id])
      owner.update(
        name: params[:name],
        email: params[:email],
        password_digest: params[:password_digest],
        city: params[:city],
        payment_info: params[:payment_info]
        )
      redirect to "/admin/#{current_admin.id}"
    else
      redirect to "/admin"
    end
  end

  delete '/owner/:id/delete' do
    owner = Owner.find_by_id(params[:id])
    owner.delete
    redirect to "/admin/#{current_admin.id}"
  end
end
