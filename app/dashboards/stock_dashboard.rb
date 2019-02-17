require 'administrate/base_dashboard'

class StockDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    stock_exchange: Field::BelongsTo,
    sector: Field::BelongsTo,
    quotes: Field::HasMany,
    holdings: Field::HasMany,
    wallets: Field::HasMany,
    id: Field::String.with_options(searchable: false),
    name: Field::String,
    ticker: Field::String,
    type: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    enabled: Field::Boolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    ticker
    stock_exchange
    sector
    enabled
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    ticker
    type
    stock_exchange
    sector
    enabled
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    ticker
    type
    stock_exchange
    sector
    enabled
  ].freeze

  # Overwrite this method to customize how stocks are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(stock)
    stock.ticker
  end
end
