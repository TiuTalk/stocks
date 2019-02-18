class Operation < ApplicationRecord
  include Wisper.model

  # Associations
  belongs_to :wallet, inverse_of: :operations
  belongs_to :stock, inverse_of: :operations

  # Validations
  validates :quantity, :price, :total, :date, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :price, :taxes, :total, numericality: { greater_than_or_equal_to: 0 }
end
