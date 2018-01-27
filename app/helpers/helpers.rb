class Helpers
  def self.checkIfParamsEmpty?(params)
    params.each do |k,v|
      #binding.pry
      if params[k.to_s].empty?
        return true
      end
    end
    return false
  end

  def self.is_logged_in?(session)
    session.key?(:id)
  end

  def self.current_user(session)
    @user = User.find(session[:id])
    @user
  end
end
