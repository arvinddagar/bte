Rails.application.routes.draw do
  devise_for :users

    # STUDENTS
  authenticated :user, lambda {|u| u.type == :student} do
    # root "accounts#student_dashboard", as: "student_root"
    resources :students, only: [:update]
    resources :tutors, only: [:index, :show]
    # get "complete_registration", to: "students#complete_registration"
  end

  # TUTORS
  authenticated :user, lambda {|u| u.type == :tutor} do
    # root "accounts#tutor_dashboard", as: "tutor_root"
    # get "complete_registration", to: "tutors#complete_registration"
    resources :students, only: [:index]
  end

  # VISITORS
  unauthenticated :user do
    resources :students, only: [:new, :create]
    resources :tutors, only: [:new, :create]
  end
  root "welcome#index"
end
