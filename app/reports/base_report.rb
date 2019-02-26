class BaseReport
  CDI = ENV.fetch('CDI', 6.4).to_f

  def initialize(date_range: default_date_range, interval: :monthly)
    @date_range = date_range
    @interval = interval
  end

  private

  attr_reader :date_range

  def each_date(cdi: false)
    dates.map do |date|
      row = { date: I18n.l(date, format: date_format) }
      row[:cdi] = cdi_return(from: date_range.begin, to: date) if cdi

      yield(date, row)
    end.compact
  end

  def dates
    list = []
    date = beginning_of_report

    while date.past?
      list << date
      date = advance_date(date)
    end

    list
  end

  def cdi_return(from:, to:)
    days = (to - from).to_i
    (days * CDI / 364).round(3)
  end

  def default_date_range
    1.year.ago.to_date..Time.zone.yesterday
  end

  def cache(keys, options = { expires_in: 1.hour })
    Rails.cache.fetch(cache_key(keys), options) do
      yield
    end
  end

  def cache_key(*parts)
    parts.map! { |part| part.try(:cache_key) || part }
    parts.join('/')
  end

  def monthly?
    @interval == :monthly
  end

  def beginning_of_report
    date = date_range.begin
    monthly? ? date.end_of_month : date.end_of_week
  end

  def advance_date(date)
    monthly? ? date.next_month.end_of_month : date.next_week.end_of_week
  end

  def date_format
    monthly? ? '%b/%y' : '%d/%b/%y'
  end
end
