# /app/models/reservation.rb
class Reservation < ActiveRecord::Base
  include ActionView::Helpers::DateHelper

  RESERVATION_TYPES = %W(free paid trial)

  belongs_to :lesson
  belongs_to :tutor
  belongs_to :student
  belongs_to :purchase

  validate :conflict, on: :create
  before_create :consume_token

  state_machine initial: :reserved do
    after_transition reserved: [:canceled], do: :return_token
    event(:cancel) { transition reserved: :canceled }
    event(:complete) { transition reserved: :completed }
  end

  def overlaps?(range)
    (starts_at - range.ends_at) * (range.starts_at - ends_at) > 0
  end

  def cancelable?
    if created_at > 30.minutes.ago
      return true
    elsif starts_at > DateTime.now + 24.hours
      return true
    else
      return false
    end
  end

  def time
    starts_at.in_time_zone(Time.zone).strftime('%l:%M%P - ') + ends_at.in_time_zone(Time.zone).strftime('%l:%M%P')
  end

  def time_until
    distance_of_time_in_words_to_now(self.starts_at.to_time)
  end


  protected

  def conflict
    if conflicts_with_another_reservation?
      errors.add(:base, "You already have a lesson booked at this time.  Click 'Book Now' to pick a different time slot.")
    elsif !corresponds_to_available_reservation? || in_green_zone?
      errors.add(:base, 'This reservation is no longer available')
    end
  end

  def conflicts_with_another_reservation?
    Reservation.where('ends_at > ?', Time.now).where('lesson_id = ? OR student_id = ?', lesson, student).with_state(:reserved).each do |reservation|
      return true if overlaps?(reservation)
    end
    false
  end

  def in_green_zone?
    starts_at < Time.now + lesson.green_zone.minutes
  end

  def corresponds_to_available_reservation?
    last_res = ReservationGenerator.new(lesson)
                                   .take_while { |n| n.starts_at <= starts_at }.last
    last_res && (last_res.starts_at == starts_at && last_res.ends_at == ends_at)
  end

  def consume_token
    TokenManager.new(self).use_token
  end

  def return_token
    TokenManager.new(self).return_token
  end
end
