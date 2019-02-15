namespace :stocks do
  desc 'Import quotes'
  task import_quotes: :environment do
    StockExchange.b3.stocks.enabled.find_each do |s|
      QuotesImporterWorker.perform_async(s.id)
    end
  end
end
