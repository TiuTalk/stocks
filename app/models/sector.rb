class Sector < ApplicationRecord
  # Associations
  belongs_to :stock_exchange, inverse_of: :sectors
  has_many :stocks, inverse_of: :sector, dependent: :destroy
  has_many :fiis, class_name: 'FII', inverse_of: :sector, dependent: :destroy
  has_many :etfs, class_name: 'ETF', inverse_of: :sector, dependent: :destroy

  # Validations
  validates :name, presence: true
end
