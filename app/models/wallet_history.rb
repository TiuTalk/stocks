class WalletHistory < ApplicationRecord
  # Associations
  belongs_to :wallet, inverse_of: :history
end
