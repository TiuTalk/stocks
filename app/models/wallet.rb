class Wallet < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :wallets
  belongs_to :stock_exchange, inverse_of: :wallets
  has_many :holdings, inverse_of: :wallet, dependent: :destroy
  has_many :stocks, through: :holdings, inverse_of: :wallets
  has_many :operations, inverse_of: :wallet

  # Validations
  validates :name, presence: true
end
