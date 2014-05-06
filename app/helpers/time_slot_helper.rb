# /app/helpers/time_slot_helper.rb
module TimeSlotHelper
  def select_for_time_with_weekday(form, weekday)
    # 15 minute increments starting at 6am
    times = TimeSlot::PRETTY_TIMES.slice(*TimeSlot::PRETTY_TIMES.keys.select {|n| n >= 6*60 && n % 15 == 0}).invert
    weekday_offset = TimeSlot::DAYS_OF_WEEK.index(weekday) * 24 * 60
    form.select :starts_at_minutes, times.each_with_object({}) {|(k,v), h| h[k] = v + weekday_offset}
  end
end
