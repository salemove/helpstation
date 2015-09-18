require 'rubygems'
require 'bundler'
require 'pry'
Bundler.setup

require 'helpstation'

Dir[File.dirname(__FILE__) + '/support/*.rb'].each {|f| require f}

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  def env
    @_env ||= { mock_service: :mock_value }
  end
end
