Rails.application.routes.draw do
  resources :time_slots

  devise_for :users

    # STUDENTS
  authenticated :user, ->(u) { u.type == :student } do
    root 'accounts#student_dashboard', as: 'student_root'
    resources :students, only: [:update]
    resources :tutors, only: [:index, :show]
    get 'complete_registration', to: 'students#complete_registration'
    resources :students, only: [:update]
  end

  # TUTORS
  authenticated :user, ->(u) { u.type == :tutor } do
    root 'accounts#tutor_dashboard', as: 'tutor_root'
    resources :students, only: [:index]
    get 'complete_registration', to: 'tutors#complete_registration'
    resources :tutors, only: [:update]
  end

  # VISITORS
  unauthenticated :user do
    resources :students, only: [:new, :create]
    resources :tutors, only: [:new, :create]
  end
  root 'welcome#index'
end
