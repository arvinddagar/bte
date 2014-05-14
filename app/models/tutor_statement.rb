# /app/models/tutor_statement.rb
class TutorStatement < ActiveRecord::Base
  belongs_to :tutor

  STATEMENT_TIME_ZONE = 'Eastern Time (US & Canada)'
  COMMISSIONS = [30, 25, 20, 10, 0]

  validates_uniqueness_of :tutor_id, scope: [:year, :month, :week]

  scope :previous_week, -> { where(week: Time.now.prev_week.wday, month: Time.now.prev_week.month, year: Time.now.prev_week.year) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where('published IS NULL OR published = ?', false).where(finalized: true) }
  scope :unfinalized, -> { where('finalized IS NULL OR finalized = ?', false) }
  scope :ordered, -> { order('year, month') }

  def self.past
    now = Time.find_zone(STATEMENT_TIME_ZONE).now
    where('(month + year * 12) < ?', now.month + now.year * 12)
  end

  def self.from_tutor(tutor, attributes = {})
    now = Time.find_zone(STATEMENT_TIME_ZONE).now
    defaults = { year: now.year, month: now.month }
    attributes.slice!(:year, :month)
    result = where(tutor_id: tutor).where(defaults.merge(attributes)).first_or_create
    result
  end

  def self.generate_all_for_current_month
    time = Time.find_zone(STATEMENT_TIME_ZONE).now
    generate_for_year_and_month(time.year, time.month)
  end

  def self.generate_all_for_previous_month
    time = Time.find_zone(STATEMENT_TIME_ZONE).now.prev_month
    generate_for_year_and_month(time.year, time.month)
  end

  def self.generate_all_for_previous_week
    # time = Time.find_zone(STATEMENT_TIME_ZONE).now.prev_week
    generate_for_year_and_month_and_week
  end

  def self.generate_for_year_and_month_and_week
    time = Time.find_zone(STATEMENT_TIME_ZONE).now.prev_week
    date_range = (time..time.end_of_week)
    reservations = Reservation.unscoped.select('DISTINCT(reservations.tutor_id), *')
                   .with_states(:completed, :reserved).where(starts_at: date_range)
                   .where(reservation_type: [:paid, :comped, :package])
    tutors = reservations.map(&:tutor)

    tutors.each {|tutor|
      TutorStatement.where(tutor_id: tutor.id, week: week, month: month, year: year).first_or_create
    }
  end

  def finalize
    return false if finalized? || !date_range.last.past?
    # self.pdf = tutorStatementPdf.new(self).pdferize
    self.finalized = true
    save
  end

  def publish
    finalized? and update_column(:published, true)
  end

  def month_name
    Date::MONTHNAMES[month]
  end

  def commission
    self[:commission] or 25
  end

  def finalized?
    changed? ? !!TutorStatement.find(self).try(:finalized) : !!self[:finalized]
  end

  def save
    !finalized? and super
  end

  def reservations
    tutor.reservations.where(starts_at: date_range).with_states(:completed, :reserved).ascending_order
  end

  def reservations_gross_payable
    reservations.where(reservation_type: [:comped, :paid, :package]).inject(0.0) do |accumulator, reservation|
      accumulator + reservation.gross_payable_value
    end
  end

  def miscellaneous_payable
    tutor_statement_miscellaneous_line_items.inject(0.0) do |acc, item|
      acc + item.amount
    end
  end

  def reservations_net_payable
    reservations_gross_payable - commission_value
  end

  def commission_value
    reservations_gross_payable * (commission / 100.0)
  end

  def total_payable
    reservations_net_payable + miscellaneous_payable
  end

  def date_range
    time = Time.find_zone(STATEMENT_TIME_ZONE).now.prev_week
    (time..time.end_of_week)
  end
end