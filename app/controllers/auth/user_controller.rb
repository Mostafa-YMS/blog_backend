class Auth::UserController < ApplicationController
  def create
    @user = User.create(user_params)
    
    if @user.save
      @user.image.attach(params[:image])      
      render json: user_serialize(@user)
    else
      render json: { message: "Something went wrong", errors: @user.errors.full_messages }
    end
  end

  private
  def user_params
    params.permit(:email, :name, :password, :image)
  end
  
  private
  def user_serialize(user)
    user_json = user.as_json(only: [:id, :email, :name])
    user_json[:image] = url_for(user.image)
    return user_json
  end
end
