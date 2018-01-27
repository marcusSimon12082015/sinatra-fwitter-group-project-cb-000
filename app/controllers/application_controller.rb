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

  get '/tweets' do
    @user = User.find(session[:id])
    erb :'/tweets/tweets'
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
end
