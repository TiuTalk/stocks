Rails.application.config.to_prepare do
	Wisper.clear if Rails.env.development?
	Wisper.subscribe(OperationListener.new, scope: Operation)
end

