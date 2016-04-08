module Helper
  def current_user
    @current_user ||= Customer.find_by_id(session[:id])
    @current_user ||= Owner.find_by_id(session[:id])
    @current_user ||= Admin.find_by_id(session[:id])
  end
  def loggen_in?
    !!session[:id]
  end
end
