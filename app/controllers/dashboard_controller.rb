class DashboardController < ApplicationController
  def show
    @user = User.find_by_id(session[:user_id])
    @user ||= User.new
  end
end
