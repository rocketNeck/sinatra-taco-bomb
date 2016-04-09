module Helper
  def current_customer
    @current_customer ||= Customer.find_by_id(session[:id])
  end
  def current_owner
    @current_owner ||= Owner.find_by_id(session[:id])
  end
  def current_admin
    @current_user ||= Admin.find_by_id(session[:id])
  end
  def current_order
    customer = Customer.find_by_id(session[:id])
    @current_order = customer.orders.last
  end
  def logged_in?
    !!session[:id]
  end
end
