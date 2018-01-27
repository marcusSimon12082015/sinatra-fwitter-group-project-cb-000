require './config/environment'
require 'rack-flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash
  configure do
    enable :sessions
    set :session_secret, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get '/' do
    erb :index
  end

  get '/users/:user_slug' do
    binding.pry
    @user = User.find_by_slug(params[:user_slug])
    erb :'/users/show'
  end

  get '/tweets' do
    begin
        @user = User.find(session[:id])
        erb :'/tweets/tweets'
    rescue ActiveRecord::RecordNotFound
        #binding.pry
        redirect to '/login'
    end
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    end
    erb :'/users/create_user'
  end

  post '/signup' do

    if !Helpers.checkIfParamsEmpty?(params) &&
      @user = User.new(username: params[:username],
              email: params[:email],
              password: params[:password])
      @user.save

      session[:id] = @user.id
      flash[:message] = "Successfully Signed Up"
      redirect to '/tweets'
    else
      flash[:message] = "All fields are required!!!"
      redirect to '/signup'
    end
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    end
    erb :'/users/login'
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    #binding.pry
    if @user.authenticate(params[:password])
      session[:id] = @user.id
      redirect to '/tweets'
    end
  end

  get '/logout' do
    session.clear
    redirect to '/login'
  end

end
