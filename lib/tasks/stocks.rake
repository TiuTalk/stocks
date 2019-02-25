namespace :stocks do
  desc 'Import quotes of enabled Stocks'
  task import_quotes: :environment do
    Stock.enabled.find_each do |stock|
      QuotesImporterWorker.perform_async(stock.id)
    end
  end

  desc 'Import quotes of enabled Stocks with holdings'
  task import_holdings_quotes: :environment do
    Stock.enabled.with_holdings.find_each do |stock|
      QuotesImporterWorker.perform_async(stock.id)
    end
  end
end
