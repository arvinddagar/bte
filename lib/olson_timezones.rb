module OlsonTimezones
  def self.timezones_from_olson(olson)
    ActiveSupport::TimeZone::MAPPING.inject([]) do |accumulator, (key, value)|
      next accumulator unless value == olson
      accumulator << key
    end
  end
end
