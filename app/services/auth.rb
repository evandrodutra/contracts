class Auth
  SECRET = Rails.application.secrets.secret_key_base
  ALGORITHM = "HS256"

  def self.issue_token(user_id)
    JWT.encode({ user: user_id }, SECRET, ALGORITHM)
  end

  def self.authenticate(token)
    token_data = decode(token)

    return false unless token_data

    User.where(id: token_data[:user]).first
  end

  def self.decode(token)
    JWT.decode(token, SECRET, true, { algorithm: ALGORITHM }).first.symbolize_keys
  rescue
    false
  end
end
