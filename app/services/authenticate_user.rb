class AuthenticateUser
  attr_accessor :errors

  def initialize(params)
    @params = params
    @username = params[:username]
    @password = params[:password]
    @errors = {}
  end

  def call
    JsonWebToken.encode(user_id: user.id) if user
  end

  private

  def user
    user = User.find_by(username: @username)
    return user if user && user.authenticate(@password)

    @errors[:user_authentication] = t('authentication.invalid_credentials')
    nil
  end

  def t(key_path)
    I18n.t(key_path.to_s)
  end
end