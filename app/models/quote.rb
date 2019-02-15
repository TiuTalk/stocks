class Quote < ApplicationRecord
  # Associations
  belongs_to :stock, inverse_of: :quotes

  # Validations
  validates :stock, :date, presence: true
  validates :date, uniqueness: { scope: :stock_id }
  validate :date_is_in_the_past

  private

  def date_is_in_the_past
    errors.add(:date, 'should be in the past') if date.present? && (date.today? || date.future?)
  end
end
