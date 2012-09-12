class SessionsController < ApplicationController
  def create
    user = unless session[:user_id]
             OmniAuthUser.create(request.env['omniauth.auth'])
           else
             OmniAuthUser.update(session[:user_id], request.env['omniauth.auth'])
           end

    session[:user_id] = user.id
    flash[:authorized_with] = request.env['omniauth.auth'].provider

    redirect_to root_path
  end
end