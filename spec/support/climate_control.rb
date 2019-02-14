module ClimateControlHelper
  def with_modified_env(options, &block)
    ClimateControl.modify(options, &block)
  end
end

RSpec.configure do |c|
  c.include ClimateControlHelper
end
