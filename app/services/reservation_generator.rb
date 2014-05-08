require 'lazy_list'
# /app/services/reservation_generator.rb
class ReservationGenerator
  def initialize(lesson)
    @lesson = lesson
  end

  def for_date(date)
    week_number = ((date.to_date - (Chronic.parse('next Sunday').to_date - 7.days)) / 7).to_i
    temp = ReservationGenerator.new(@lesson)
    temp.lazy_list = LazyList.new do |yielder|
      @lesson.time_slots.sort.each do |time_slot|
        yielder.yield build_reservation(time_slot, week_number)
      end
    end.select { |n| n.starts_at.to_date == date.to_date && reservable?(n) }
    temp
  end

  def starting_on(date)
    temp = ReservationGenerator.new(@lesson)
    temp.lazy_list = lazy_list.select{ |n| n.starts_at.to_date >= date.to_date }
    temp
  end

  def method_missing(method_name, *args, &block)
    if lazy_list.respond_to? method_name
      result = lazy_list.send(method_name, *args, &block)
      if result.kind_of? LazyList
        temp = ReservationGenerator.new(@lesson)
        temp.lazy_list = result
        temp
      else
        result
      end
    else
      raise NoMethodError
    end
  end

  private

  def build_reservation(ts, week_number)
    Reservation.new(lesson: @lesson, starts_at: ts.starts_at_for_week(week_number, time_zone: @lesson.time_zone), ends_at: ts.ends_at_for_week(week_number, time_zone: @lesson.time_zone))
  end

  def lazy_list
    @lazy_list ||= LazyList.new do |yielder|
      @lesson.time_slots.sort.cycle(@lesson.weeks_visible + 1).each_with_index do |time_slot, count|
        yielder.yield build_reservation(time_slot, count / @lesson.time_slots_count)
      end
    end.select { |n| reservable?(n) }
  end

  def reservable?(reservation)
    accepting_range.cover?(reservation.starts_at) && !conflict(reservation)
  end

  def conflict(reservation)
    conflicting_ranges.each do |conflict|
      (conflict.first - reservation.ends_at) * (reservation.starts_at - conflict.last) <= 0 or return true
    end
    false
  end

  def conflicting_ranges
    @conflicting_ranges ||= [] + @lesson.reservations.with_state(:reserved).reject { |n| n.ends_at.past? }.map { |n| (n.starts_at..n.ends_at) }
  end

  def accepting_range
    @accepting_range ||= (Time.now + @lesson.green_zone.minutes)..(Time.now + @lesson.weeks_visible.weeks)
  end

  protected

  def lazy_list=(list)
    @lazy_list = list
  end
end
