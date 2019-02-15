namespace :factory_bot do
  desc 'Verify that all FactoryBot factories are valid'
  task lint: :environment do
    if Rails.env.test?
      ActiveRecord::Base.transaction do
        FactoryBot.lint
        raise ActiveRecord::Rollback
      end
    else
      system('RAILS_ENV=test bundle exec rake factory_bot:lint')
      raise if $CHILD_STATUS.exitstatus.nonzero?
    end
  end
end
