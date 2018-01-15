class User < ApplicationRecord
  has_secure_password

  has_many :contracts

  validates :full_name, :email, :password_digest, presence: true
  validates :email, format: { with: /\A[^@\s]+@[^@\s]+\z/ }, uniqueness: { case_sensitive: false }
end
