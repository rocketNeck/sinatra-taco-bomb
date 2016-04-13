module Helper

  def current_customer
    @current_customer ||= Customer.find_by_id(session[:id])
  end

  def current_owner
    @current_owner ||= Owner.find_by_id(session[:id])
  end

  def current_admin
    @current_admin ||= Admin.find_by_id(session[:id])
  end

  def current_order
    @current_order = current_customer.orders.last
  end

  def logged_in?
    !!current_owner || !!current_admin || !!current_customer
  end
end
