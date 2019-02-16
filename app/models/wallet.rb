class Wallet < ApplicationRecord
  # Associations
  belongs_to :user, inverse_of: :wallets
  belongs_to :stock_exchange, inverse_of: :wallets

  # Validations
  validates :name, presence: true
end
