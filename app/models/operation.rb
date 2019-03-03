class Operation < ApplicationRecord
  include Wisper.model

  # Associations
  belongs_to :wallet, inverse_of: :operations
  belongs_to :stock, inverse_of: :operations

  # Scopes
  scope :purchase, -> { where(type: 'Operations::Purchase') }
  scope :sale, -> { where(type: 'Operations::Sale') }
  scope :purchase_or_sale, -> { purchase.or(sale) }
  scope :on_or_before, ->(date) { where("#{table_name}.date <= ?", date) }

  # Validations
  validates :quantity, :price, :total, :date, presence: true
  validates :quantity, numericality: { only_integer: true, other_than: 0 }
  validates :price, :taxes, numericality: { greater_than_or_equal_to: 0 }
  validates :total, numericality: { other_than: 0 }

  # Callbacks
  before_validation :calculate_total

  private

  def calculate_total
    return if quantity.nil? || price.nil?

    self.total = (quantity * price) + taxes
  end
end
