class UserSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :jwt, :created_at, :updated_at

  def jwt
    Auth.issue_token(object.id)
  end
end
