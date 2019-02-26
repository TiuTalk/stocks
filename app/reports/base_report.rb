class BaseReport
  CDI = ENV.fetch('CDI', 6.4).to_f

  def initialize(date_range: default_date_range, interval: 1.week, date_format: :short)
    @date_range = date_range
    @interval = (interval / 1.day).to_i
    @date_format = date_format
  end

  private

  attr_reader :date_range, :interval

  def each_date(cdi: false)
    date_range.step(interval).map do |date|
      row = { date: I18n.l(date, format: @date_format) }
      row[:cdi] = cdi_return(from: date_range.begin, to: date) if cdi
      yield(date, row)
    end.compact
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
end
