require_relative 'day.rb'

class ActivePeriod::Holiday < ActivePeriod::Day

  # @!attribute [r] name
  #   @return [String] The name of the holiday
  attr_reader :name

  # @!attribute [r] regions
  #   @return [<Symbol>] regions where the Holiday occure
  attr_reader :regions


  # @param date [...] A valid param for Period.day(...)
  # @param name [String] The name of the Holiday
  # @param regions [<Symbol>] region where the Holiday occure
  # @return [Type] ActivePeriod::Holiday
  # @raise RuntimeError if the gem "holidays" is not included
  def initialize(date: , name:, regions: )
    raise I18n.t(:gem_require, scope: %i[active_period holiday_period]) unless Object.const_defined?('Holidays')
    super(date)

    @name = name
    @regions = regions
  end

  def next
    raise NotImplementedError
  end
  alias succ next

  def prev
    raise NotImplementedError
  end

  def _period
    self.class._period
  end

  def self._period
    'day'
  end

  # Shift a period to the past acording to her starting point
  # @return [self] A new period of the same kind
  def -(duration)
    raise NotImplementedError
  end

  # Shift a period to the past acording to her ending point
  # @return [self] A new period of the same kind
  def +(duration)
    raise NotImplementedError
  end

  def strftime(format)
    from.strftime(format)
  end

  def to_s(format: '%d/%m/%Y')
    strftime(format)
  end

  def i18n(&block)
    return yield(from, to) if block.present?

    I18n.t(:default_format,
           scope:   i18n_scope,
           name:    name,
           wday:    I18n.l(from, format: '%A').capitalize,
           day:     from.day,
           month:   I18n.l(from, format: '%B').capitalize,
           year:    from.year)
  end

  def i18n_scope
    [:active_period, :holiday_period]
  end

end
