# frozen_string_literal: true
class User < ApplicationRecord
  attr_accessor :username, :password
  validates :username, presence: true, uniqueness: true
  validates :password, presence: true
  before_save :encrypt_password
  private
  def encrypt_password
    self.password = BCrypt::Password.create(password)
  end
end
