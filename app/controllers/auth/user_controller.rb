class Auth::UserController < ApplicationController
  skip_before_action :authorized, only: [:login, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    @user = User.create(user_params)

    if @user.save
      @user.image.attach(params[:image])
      @token = encode_token(user_id: @user.id)
      render json: { user: user_serialize(@user), token: @token }, status: :created
    else
      render json: { message: "Something went wrong", errors: @user.errors.full_messages }
    end
  end

  def me
    render json: user_serialize(current_user), status: :ok
  end

  def login
    @user = User.find_by!(email: login_params[:email])
    if @user.authenticate(login_params[:password])
      @token = encode_token(user_id: @user.id)
      render json: {
               user: user_serialize(@user),
               token: @token,
             }, status: :accepted
    else
      render json: { message: "Incorrect password" }, status: :unauthorized
    end
  end

  private

  def login_params
    params.permit(:email, :password)
  end

  def handle_record_not_found(e)
    render json: { message: "User doesn't exist" }, status: :unauthorized
  end

  def user_params
    params.permit(:email, :name, :password, :image)
  end

  def user_serialize(user)
    user_json = user.as_json(only: [:id, :email, :name])
    user_json[:image] = url_for(user.image)
    return user_json
  end
end
