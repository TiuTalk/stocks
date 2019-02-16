class User < ApplicationRecord
  # Associations
  has_many :wallets, inverse_of: :user, dependent: :destroy

  # Validations
  validates :name, presence: true

  # Devise modules
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
end
