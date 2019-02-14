# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def fetch_url(url)
  body = Net::HTTP.get(URI.parse(url))
  Nokogiri::HTML(body)
end

if StockExchange.count.zero?
  puts "=> Creating stock exchanges..."

  [
    { name: 'B3', code: 'B3', alpha_advantage_code: 'SAO', country: 'BRA', timeonze: 'America/Sao_Paulo', open: '09:00:00', close: '18:00:00' },
    { name: 'NYSE', code: 'NYSE', alpha_advantage_code: 'NYSE', country: 'USA', timeonze: 'America/New_York', open: '09:00:00', close: '18:00:00' }
  ].map(&StockExchange.method(:create!))

  puts "  - Created #{StockExchange.count} stock exchanges"
end

B3 = StockExchange.b3

if B3.stocks.count.zero?
  b3_regex = %r{-([A-Z0-9]{4}[0-9]{1,2}B?)/cotacao}
  puts "=> Importing #{B3.name} stocks..."
  ('A'..'Z').each do |letter|
    puts "  - Importing stocks with letter #{letter}..."
    doc = fetch_url("https://br.advfn.com/bolsa-de-valores/bovespa/#{letter}")
    doc.css('a[title*=Cotação]').each do |link|
      next unless link.attr(:href) =~ b3_regex

      ticker = link.attr(:href).match(b3_regex)[1].strip
      name = link.text.strip

      B3.stocks.create!(name: name, ticker: ticker)
    end

    sleep(0.5)
  end
  puts "  - Imported #{B3.stocks.count} #{B3.name} stocks"
end

if B3.fiis.count.zero?
  puts "=> Importing #{B3.name} FIIs..."
  doc = fetch_url("https://www.clubefii.com.br/fundo_imobiliario_lista")
  doc.css('.tabela_principal tr').each_with_index do |row, i|
    next if i.zero?

    ticker = row.children[1].text.strip
    name = row.children[3].text.strip

    B3.fiis.create!(name: name, ticker: ticker)
  end
  puts "  - Imported #{B3.fiis.count} #{B3.name} FIIs"
end

if B3.etfs.count.zero?
  puts "=> Importing #{B3.name} ETFs..."
  doc = fetch_url('https://br.investing.com/etfs/brazil-etfs')
  doc.css('#etfs tr').each_with_index do |row, i|
    next if i.zero?

    ticker = row.children[2].text.strip
    name = row.children[1].text.strip

    B3.etfs.create(name: name, ticker: ticker)
  end
  puts "  - Imported #{B3.etfs.count} #{B3.name} ETFs"
end
