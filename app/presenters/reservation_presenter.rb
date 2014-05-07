# /app/presenters/reservation_presenter.rb
class ReservationPresenter < BasePresenter
  presents :reservation

  def name
    if current_user.tutor?
      link_to reservation.student.name, new_student_message_path(reservation.student)
    else
      link_to reservation.tutor.name, reservation.tutor
    end
  end

  def lesson_time
    reservation.starts_at.strftime('%l:%M') + ' - ' + reservation.ends_at.strftime('%l:%M %p %Z')
  end

  def description
    reservation.starts_at.strftime('%A, %b %e')
  end

  def date_and_time
    reservation.starts_at.strftime('%A, %b %e %l:%M - ') + reservation.ends_at.strftime('%l:%M %p %Z')
  end

  def avatar
    # if current_user.student?
    #   content_tag :div, class: 'teacher-pic' do
    #     image_tag(reservation.teacher.avatar.url(:medium))
    #   end
    # end
  end

  def join_button
    if reservation.starts_at - 1.hour < DateTime.now
      link_to 'Join Lesson', reservation_path(reservation), class: 'small round button'
    else
      link_to "Starts in #{reservation.time_until}", '#', class: "small round button join", disabled: :true, rel: reservation.starts_at
    end
  end

  def reschedule_link
    if current_user.student? && reservation.cancelable?
      link_to 'Reschedule Lesson', reservation_path(reservation), method: 'put', class: 'contact', confirm: 'Are you sure you want to reschedule this lesson?'
    elsif current_user.tutor?
      link_to 'Cancel Lesson', reservation_path(reservation), method: 'put', class: 'contact', confirm: 'Are you sure you want to cancel this lesson?'
    end
  end

  def book_button
    if current_user
      book_button_normal
    else
      book_button_xhr
    end
  end

  def book_button_iframe
    reservation_attributes = reservation.attributes.slice('lesson_id', 'starts_at', 'ends_at')
    result = []

    result << link_to('Book Now', new_purchase_path(sign_up: true, reservation: reservation_attributes), class: 'tiny round button grey', id: reservation.starts_at.to_s.gsub(" ", "_"), target: '_blank')

    result.join(' ').html_safe
  end

  private

  def book_button_xhr
    reservation_attributes = reservation.attributes.slice('lesson_id', 'starts_at', 'ends_at')
    result = []

    result << link_to('Book Now', new_purchase_path(sign_up: true, reservation: reservation_attributes, modal: true), class: 'tiny round button grey', id: reservation.starts_at, remote: true)

    result.join(' ').html_safe
  end

  def book_button_normal
    reservation_attributes = reservation.attributes.slice('lesson_id', 'starts_at', 'ends_at')
    result = []

    result << link_to('Book Now', new_purchase_path(sign_up: true, reservation: reservation_attributes), class: 'tiny round button grey', id: reservation.starts_at.to_s.gsub(" ", "_"))

    result.join(' ').html_safe
  end
end
