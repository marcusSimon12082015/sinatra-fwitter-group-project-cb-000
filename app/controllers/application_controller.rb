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
#USER Operations#

  get '/users/:user_slug' do
    #binding.pry
    @user = User.find_by_slug(params[:user_slug])
    erb :'/users/show'
  end
#USER Opeartions END#

#Tweets operations#
  get '/tweets' do
    begin
        @user = User.find(session[:id])
        erb :'/tweets/tweets'
    rescue ActiveRecord::RecordNotFound
        redirect to '/login'
    end
  end

  get '/tweets/new' do
    if Helpers.is_logged_in?(session)
      erb :'/tweets/create_tweet'
    else
      redirect to 'login'
    end
  end

  post '/tweets' do
    if !Helpers.checkIfParamsEmpty?(params)
      @user = User.find(session[:id])
      @tweet = Tweet.create(content: params[:content])
      @user.tweets << @tweet
    else
      flash[:message] = "All fields are required!!!"
      redirect to '/tweets/new'
    end
  end

  get '/tweets/:id' do
    if Helpers.is_logged_in?(session)
      @tweet = Tweet.find(params[:id])
      erb :'/tweets/show_tweet'
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    begin
      @tweet = Tweet.find(params[:id])
      if Helpers.is_logged_in?(session)
        if Helpers.current_user(session).id == @tweet.user_id
          erb :'/tweets/edit_tweet'
        else
          redirect to '/tweets'
        end
      else
        redirect to '/login'
      end
    rescue ActiveRecord::RecordNotFound
      redirect to '/login'
    end
  end

  post '/tweets/:id/delete' do
    @tweet = Tweet.find(params[:id])
    if Helpers.is_logged_in?(session)
      if Helpers.current_user(session).id == @tweet.user_id
        @tweet.destroy
      end
    end
    redirect to '/tweets'
  end

  post '/tweets/:id' do
    if params.key?("content") && !params[:content].empty?
      @tweet = Tweet.find(params[:id])
      @tweet.update(content: params[:content])
    else
      flash[:message] = "All fields are required!!!"
      redirect to ("/tweets/#{params[:id]}/edit")
    end
  end
#Tweets operations END#

#Signup operations#
  get '/signup' do
    if Helpers.is_logged_in?(session)
      redirect to '/tweets'
    end
    erb :'/users/create_user'
  end

  post '/signup' do

    if !Helpers.checkIfParamsEmpty?(params)
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

#Signup operations END#

#Login/Logout operations#

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

#Login/Logout operations END#

end
