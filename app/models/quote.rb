class Quote < ApplicationRecord
  # Associations
  belongs_to :stock, inverse_of: :quotes

  # Validations
  validates :stock, :date, presence: true
  validates :date, uniqueness: { scope: :stock_id }
  validates :open, :close, :high, :low, numericality: { greater_than_or_equal_to: 0 }
  validates :volume, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :date_is_in_the_past

  private

  def date_is_in_the_past
    errors.add(:date, 'should be in the past') if date.present? && (date.today? || date.future?)
  end
end
