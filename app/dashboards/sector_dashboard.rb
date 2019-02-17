require 'administrate/base_dashboard'

class SectorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    stock_exchange: Field::BelongsTo,
    stocks: Field::HasMany,
    fiis: Field::HasMany,
    etfs: Field::HasMany,
    id: Field::String.with_options(searchable: false),
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    name
    stock_exchange
    stocks
    fiis
    etfs
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    name
    stock_exchange
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
    stock_exchange
  ].freeze

  # Overwrite this method to customize how sectors are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(sector)
    sector.name
  end
end
