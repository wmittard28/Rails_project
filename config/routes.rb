Rails.application.routes.draw do
  root 'home#welcome'
  get  '/about' => 'home#about'

  get    '/home'                 => 'sessions#index'
  get    '/login'                => 'sessions#new'
  get 'google_signup', to: redirect('/auth/google_oauth2'), as: 'google_signup'
  get "/auth/:provider/callback" => "sessions#create"
  post   '/sessions'             => 'sessions#create'
  delete '/logout'               => 'sessions#destroy'

  get    '/companies/:slug'   => 'companies#show', :param => :slug, :as => "company"

  resources :job_applications, :except => [:index, :new, :create] do
    resources :notes, :except => [:index]
  end

  get    '/signup'             => 'users#new'
  post   '/users'              => 'users#create'
  get    '/:slug'              => 'users#show',         :param => :slug, :as => "user"
  get    '/:slug/edit'         => 'users#edit',         :param => :slug, :as => "edit_user"
  patch  '/:slug'              => 'users#update',       :param => :slug
  put    '/:slug'              => 'users#update',       :param => :slug
  delete '/:slug'              => 'users#destroy',      :param => :slug

  get    '/:slug/companies' => 'companies#index', :param => :slug, :as => "companies"

  get    '/:slug/job_applications'      => 'job_applications#index',      :param => :slug, :as => "job_applications"
  get    '/:slug/job_applications/new'  => 'job_applications#new',        :param => :slug, :as => "new_job_application"
  post   '/:slug/job_applications'      => 'job_applications#create'
end
