class TimeSlot < ActiveRecord::Base
  DAYS_OF_WEEK = %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday)

  #hash of minutes past midnight mapped to pretty time strings
  PRETTY_TIMES = Hash[(0..1439).map {|n| [n, "#{(n/60 == 0 || n/60 == 12 ? 12 : n/60 % 12)}:#{(n % 60).to_s.rjust(2,'0')} #{n/60 < 12 ? 'AM' : 'PM'}"]}]

  # belongs_to :tutor, counter_cache: true
  # delegate :time_zone, to: :tutor
  # validates_presence_of :tutor
  validates :starts_at_minutes, inclusion: (0..(24*60*7-1))
  validates :lesson_duration, numericality: { greater_than: 0, less_than: 7*24*60 }
  validate :overlap, on: :create

  before_validation :set_lesson_duration, on: :create

  def ends_at_minutes
    (starts_at_minutes + lesson_duration) % (7*24*60)
  end

  def weekday
    DAYS_OF_WEEK[(starts_at_minutes / (24*60)).to_i]
  end

  def starts_at_time
    PRETTY_TIMES[starts_at_minutes % (24*60)]
  end

  def ends_at_time
    PRETTY_TIMES[ends_at_minutes % (24*60)]
  end

  def starts_at_for_week(week_number, options = {})
    options[:time_zone] ||= time_zone
    Chronic.time_class = Time.find_zone(options[:time_zone])
    Chronic.parse('next sunday').beginning_of_day + starts_at_minutes.minutes + week_number.weeks - 1.week
  end

  def ends_at_for_week(week_number, options = {})
    options[:time_zone] ||= time_zone
    starts_at_for_week(week_number, options) + lesson_duration.minutes
  end

  def change_time_zone(previous, current)
    offset = (Time.find_zone(current).utc_offset - Time.find_zone(previous).utc_offset) / 60
    self.starts_at_minutes = (starts_at_minutes + offset) % (7*24*60)
    save
  end

  def <=>(other)
    #starts_at_for_week(0) - other.starts_at_for_week(0)
    starts_at_minutes - other.starts_at_minutes
  end

  private

  def set_lesson_duration
    self.lesson_duration = tutor.lesson_duration
  end

  def overlap
    # binding.pry
    tutor.time_slots.each do |ts|
      errors.add(:base, 'Conflict with existing time slot') and return if overlaps?(ts)
    end
  end

  def overlaps?(ts)
    if starts_at_minutes > ends_at_minutes && ts.starts_at_minutes > ts.ends_at_minutes
      true
    elsif starts_at_minutes > ends_at_minutes || ts.starts_at_minutes > ts.ends_at_minutes
      (starts_at_minutes - ts.ends_at_minutes) * (ts.starts_at_minutes - ends_at_minutes) < 0
    else
      (starts_at_minutes - ts.ends_at_minutes) * (ts.starts_at_minutes - ends_at_minutes) > 0
    end
  end
end
