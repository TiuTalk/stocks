class Holding < ApplicationRecord
  # Associations
  belongs_to :wallet, inverse_of: :holdings
  belongs_to :stock, inverse_of: :holdings

  # Callbacks
  after_save :check_quantity, if: :saved_change_to_quantity?

  private

  def check_quantity
    destroy if quantity.zero?
  end
end
