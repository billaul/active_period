require_relative 'active_period/version.rb'
require 'active_support/all'
require 'i18n'
require "date"

I18n.load_path << File.expand_path("../config/locales/en.yml", __dir__)
I18n.load_path << File.expand_path("../config/locales/fr.yml", __dir__)

require_relative 'numeric.rb'
require_relative 'date.rb'
require_relative 'range.rb'
require_relative 'active_period/collection.rb'
require_relative 'active_period/comparable.rb'
require_relative 'active_period/free_period.rb'
require_relative 'active_period/standard_period.rb'
require_relative 'active_period/day.rb'
require_relative 'active_period/week.rb'
require_relative 'active_period/month.rb'
require_relative 'active_period/quarter.rb'
require_relative 'active_period/year.rb'
require_relative 'period.rb'

module ActivePeriod

end
