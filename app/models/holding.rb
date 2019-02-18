class Holding < ApplicationRecord
  # Associations
  belongs_to :wallet, inverse_of: :holdings
  belongs_to :stock, inverse_of: :holdings
end
