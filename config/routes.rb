Rails.application.routes.draw do

  resources :tutor_statements

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # STUDENTS
  authenticated :user, ->(u) { u.type == :student } do
    root 'accounts#student_dashboard', as: 'student_root'
    resources :students, only: [:update]
    resources :tutors, only: [:index, :show]
    resources :purchases, only: [:new, :create]
    get 'complete_registration', to: 'students#complete_registration'
  end

  # TUTORS
  authenticated :user, ->(u) { u.type == :tutor } do
    root 'accounts#tutor_dashboard', as: 'tutor_root'
    resources :tutors, only: [:show, :update]
    resources :lessons do
      resources :time_slots, only: [:index, :create, :destroy]
    end
    get 'complete_registration', to: 'tutors#complete_registration'
    get 'subcategory', to: 'lessons#sub_category'
  end

  # USERS
  authenticated :user do
    resources :conversations, only: [:index, :show, :new, :create, :send] do
      member do
        post :reply
        post :trash
        post :untrash
      end
    end
    resources :statements, only: :show, controller: 'teacher_statements', as: 'teacher_statements' do
      get :show, defaults: {format: 'pdf'}, on: :member
    end
  end

  # VISITORS
  unauthenticated :user do
    resources :students, only: [:new, :create]
    resources :tutors, only: [:new, :create]

  end

  # EVERYONE
  resources :lessons, only: [:show]
  resources :reservations, only: [:create, :index, :show, :update] do
    get :available, on: :collection
    get :days, on: :collection
    get :confirm, on: :member
  end

  get 'search' => 'lessons#index'
  resources :pages, except: :show
  get ':id', to: 'pages#show', as: :static_page
  root 'welcome#index'
end
