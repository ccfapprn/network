Rails.application.routes.draw do

  resources :check_in_responses

  resources :check_in_surveys

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # Static Pages
  root 'static#splash'
  get 'home' => "health_data#index"
  get 'about' => 'static#about'
  get 'resources' => 'static#resources'
  get 'badge_list' => 'home#badge_list'


  get 'external_link_warning' => 'static#external_link_warning'
  #Content Pages
  get 'content/:page' => 'static#content'
  get 'content/' => 'static#content'


  get 'privacy_policy_document' => 'static#content', :page => "privacy_policy"
  get 'terms_of_service' => 'static#content', :page => "terms_of_service"
  get 'contact' => 'static#content', :page => "contact"

  devise_scope :user do
    get 'registrations/confirm/:token' => 'registrations#confirm_alt_email', as: 'registrations_confirm_alt_email'
  end

  # Research Topics
  #match 'research_topic/:id', to: "research_topics#show", as: :research_topic, via: :get
  #match 'research_questions', to: 'research_topics#index', via: :get, as: :research_topics
  #match 'research_questions/new', to: 'research_topics#new', via: :get, as: :new_research_topic
  match 'research_topics_tab', to: "research_topics#research_topics", via: :get, as: :research_topics_ajax
  get 'vote_counter' => 'research_topics#vote_counter'
  match 'comment_on_research_topic', to: "research_topics#comment", via: [:post], as: :comment_on_research_topic
  resources :research_topics

  # Research Section
  #get 'research_karma' => 'research#research_karma'
  #get 'research_today' => 'research#research_today'
  get 'research_surveys' => 'research#research_surveys', as: :surveys


  get 'research' => 'research#index'
  get 'research_prioritization' => 'research#index'
  get 'research_active_studies' => 'research#active_studies'
  get 'research_completed_research' => 'research#completed_research'
  get 'research_my_contributions' => 'research#my_contributions'


  get 'data_connections' => 'research#data_connections'

  # Surveys
  get 'research_surveys/report/:answer_session_id', to: 'surveys#show_report', as: :survey_report
  get 'research_surveys/:question_flow_id', to: 'surveys#start_survey', as: :start_survey
  get 'research_surveys/:answer_session_id/:question_id', to: 'surveys#ask_question', as: :ask_question
  match 'research_surveys/process_answer', to: 'surveys#process_answer', via: :post, as: :process_answer
  get 'questions/frequencies(/:question_id/:answer_session_id)', to: "questions#frequencies", as: :question_frequencies, format: :json
  get 'questions/typeahead/:question_id', to: "questions#typeahead", as: :question_typeahead, format: :json

  # Health Data Section
  get 'health_data' => 'health_data#index'
  get 'health_data/my_trends' => 'health_data#index', as: :my_trends
  get 'health_data/my_health_measures' => 'health_data#my_health_measures', as: :my_health_measures
  get 'health_data/my_dashboard' =>  'health_data#my_dashboard', as: :my_dashboard
  get 'health_data/my_connections' =>  'health_data#my_connections', as: :my_connections
  get 'health_data/load_connections' =>  'health_data#load_connections', as: :load_connections



  get 'data_reports' => 'health_data#reports'
  get 'data_medications' => 'health_data#medications'
  get 'data_intro' => 'health_data#intro'
  match 'check_in', to: "health_data#check_in", via: :post, as: :check_in


  # members Section
  match 'members', to: 'members#index', via: :get, as: 'members' # show
  #match 'members/profile', to: 'members#profile', as: 'social_profile', via: :get #edit
  match 'members/profile', to: 'members#update_profile', as: 'update_social_profile', via: [:put, :post, :patch] # update
  match 'locations', via: :get, as: :locations, format: :json, to: 'members#locations'


  # Blog Section
  get 'blog' => 'blog#index'
  #get 'blog_findings' => 'blog#blog_findings'


  # Account Section
  match 'account/account', to: 'account#account', as: 'social_profile', via: :get #edit
  get 'account' => 'account#account'
  get 'account_export' => 'account#account_export'
  match 'consent', to: "account#consent", as: :consent, via: [:get, :post]
  match 'privacy_policy', to: "account#privacy_policy", as: :privacy, via: [:get, :post]
  match 'update_account', to: 'account#update', as: 'update_account', via: :patch
  match 'change_password', to: 'account#change_password', as: 'change_password', via: :patch

  # Discussion
  match 'members/discussion/terms_and_conditions', to: 'account#terms_and_conditions', via: :get, as: :terms_and_conditions

  # Admin Section
  get 'admin' => 'admin#blog'
  match 'admin/users', to: 'admin#users', as: 'admin_users', via: [:get, :post]
  get 'admin/profiles' => 'admin#profiles', as: 'admin_profiles'
  get 'admin/surveys' => 'admin#surveys', as: 'admin_surveys'
  get 'admin/blog' => 'admin#blog', as: 'admin_blog'
  get 'admin/notifications' => 'admin#notifications', as: 'admin_notifications'
  get 'admin/research_topics' => 'admin#research_topics', as: 'admin_research_topics'
  get 'admin/research_topic/:id' => 'admin#research_topic', as: 'admin_research_topic'


  match 'add_role', to: "admin#add_role_to_user", via: :post, as: :add_role, format: :js
  match 'remove_role', to: "admin#remove_role_from_user", via: :post, as: :remove_role, format: :js
  match 'destroy_user', to: "admin#destroy_user", via: :post, as: :destroy_user, format: :js

  # Development/System
  get 'pprn' => 'application#toggle_pprn_cookie'

  # Voting on Questions
  resources :questions
  match 'vote', to: 'votes#vote', via: :post, as: :vote
  match 'vote', to: 'research_topics#index', via: :get, as: :vote_fake

  # Blog and Notification Posts
  resources :posts, except: [:show, :index]

  # Custome Devise Controller Overrides
  devise_for :user, controllers: { registrations: 'registrations', sessions: 'sessions'}

  # Pairing Wizard
  devise_scope :user do
    get 'pairing_wizard' => 'registrations#pairing_wizard'
    post 'pairing_wizard' => 'registrations#pairing_wizard' #enables trying specified email
    get 'redirect_to_lcp_reg' => 'registrations#redirect_to_lcp_reg'
  end

  # This line mounts Forem's routes at /forums by default.
  # This means, any requests to the /forums URL of your application will go to Forem::ForumsController#index.
  # If you would like to change where this extension is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Forem relies on it being the default of "forem"
  mount Forem::Engine, :at => '/members/discussion'

# # Authentication
#   devise_for :user, skip: [:sessions, :passwords, :confirmations, :registrations]
#   as :user do
#     # session handling
#     get     '/login'  => 'devise/sessions#new',     as: 'new_user_session'
#     post    '/login'  => 'devise/sessions#create',  as: 'user_session'
#     delete  '/logout' => 'devise/sessions#destroy', as: 'destroy_user_session'

#     # joining
#     # get   '/join' => 'devise/registrations#new',    as: 'new_user_registration'
#     # post  '/join' => 'devise/registrations#create', as: 'user_registration'

#     # scope '/account' do
#     #   # password reset
#     #   get   '/reset-password'        => 'devise/passwords#new',    as: 'new_user_password'
#     #   put   '/reset-password'        => 'devise/passwords#update', as: 'user_password'
#     #   post  '/reset-password'        => 'devise/passwords#create'
#     #   get   '/reset-password/change' => 'devise/passwords#edit',   as: 'edit_user_password'

#     #   # confirmation
#     #   get   '/confirm'        => 'devise/confirmations#show',   as: 'user_confirmation'
#     #   post  '/confirm'        => 'devise/confirmations#create'
#     #   get   '/confirm/resend' => 'devise/confirmations#new',    as: 'new_user_confirmation'

#     #   # settings & cancellation
#     #   get '/cancel'   => 'devise/registrations#cancel', as: 'cancel_user_registration'
#     #   get '/settings' => 'devise/registrations#edit',   as: 'edit_user_registration'
#     #   put '/settings' => 'devise/registrations#update'

#     #   # account deletion
#     #   delete '' => 'devise/registrations#destroy', as: 'destroy_user_registration'
#     # end
#   end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
