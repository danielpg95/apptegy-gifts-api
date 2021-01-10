class AuthorizeApiRequest
  attr_reader :headers
  attr_accessor :errors

  def initialize(headers = {})
    @headers = headers
    @errors = {}
  end

  def call
    user
  end

  private

  def user
    @user = User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    @user || invalid_token_meesage && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    headers['Authorization'].split(' ').last if headers['Authorization'].present?
  end

  def invalid_token_meesage
    @errors[:token] = t('authorization.invalid_token')
  end

  def t(key_path)
    I18n.t(key_path)
  end
end