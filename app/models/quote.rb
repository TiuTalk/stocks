class Quote < ApplicationRecord
  # Associations
  belongs_to :stock, inverse_of: :quotes

  # Validations
  validates :stock, :date, presence: true
  validates :date, uniqueness: { scope: :stock_id }
end
