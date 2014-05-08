# /app/services/reservation_updater.rb
class ReservationUpdater
  def self.call
    Reservation.where('ends_at < ?', Time.now - 2.hours).with_state(:reserved).each do |reservation|
      reservation.complete
    end
  end
end
