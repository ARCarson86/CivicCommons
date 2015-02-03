Civiccommons::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  constraints(:host => "www.theciviccommons.com") do
    # Won't match root path without brackets around "*x". (using Rails 3.0.3)
    match "(*x)" => redirect { |params, request|
      URI.parse(request.url).tap { |x| x.host = "theciviccommons.com" }.to_s
    }
  end


  delete "/users/:id/:provider/unlink" => "unlink#delete", as: :unlink

  #Private Label Routes
  constraints PrivateLabelConstraint do
    devise_for :people, :controllers => { :registrations => 'private_labels/registrations', :confirmations => 'private_labels/confirmations', :sessions => 'private_labels/sessions', :omniauth_callbacks => "private_labels/registrations/omniauth_callbacks", :passwords => 'passwords'},
      :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :registration => 'register', :sign_up => 'new' }
    devise_scope :person do
      get "/registrations/agree_to_terms", to: "private_labels/registrations#present_terms", as: "agree_to_terms"
      post "/registrations/agree_to_terms", to: "private_labels/registrations#agree_to_terms"
    end
    namespace :private_labels, path: '' do
      root to: 'homepage#show'
      namespace "admin" do
        root to: 'dashboard#show'
        get '/dashboard', to: 'dashboard#show'

        get '/private_label', to: 'private_label#show'
        put '/private_label', to: 'private_label#update'
        get '/private_label/edit', to: 'private_label#edit'

        resources :private_label_people, only: [:index, :destroy] do
          put 'toggle_admin', on: :member
        end
        resources :conversations, except: [:destroy]
        resources :contributions
        resources :pages
        resource :sidebar, only: [:edit, :update, :create]
      end
      match '/search/results', to: 'search#results', as: 'search'
      resources :people, only: [:show, :new, :create, :edit, :update]
      resources :conversations, only: [:index, :show] do
        resources :contributions do
          get 'tos', on: :member
          post 'tos', on: :member, action: :tos_flag
        end
      end

      resources :pages, only: [:show]

      post 'contact', to: 'forms#contact'
      
      get '*path', to: 'application#raise_routing_error'
    end
  end

  #Application Root
  root to: "homepage#show"

  get "/health_check" => "homepage#health_check"

  #reports
  get '/admin/reports',                                 to: 'admin/reports#index',                           as: 'reports'     
  get '/admin/member-report',                          to: 'admin/reports#member_report',                    as: 'member_report'                  
  get '/admin/conversation-summary',                   to: 'admin/reports#conversation_summary',             as: 'conversation_summary'
  get '/admin/individual-project-stats',               to: 'admin/reports#individual_project_stats',         as: 'individual_project_stats'
  get '/admin/project-conversations',                  to: 'admin/reports#project_conversations',            as: 'project_conversations'
  get '/admin/project-overview',                       to: 'admin/reports#project_overview',                 as: 'project_overview'

  #authentication
  post '/authentication/decline_fb_auth',              to: 'authentication#decline_fb_auth',                 as: 'decline_fb_auth'
  get  '/authentication/conflicting_email',            to: 'authentication#conflicting_email',               as: 'conflicting_email'
  post '/authentication/conflicting_email',            to: 'authentication#update_conflicting_email',        as: 'update_conflicting_email'
  get   '/authentication/fb_linking_success',          to: 'authentication#fb_linking_success',              as: 'fb_linking_success'
  get   '/authentication/registering_email_taken',     to: 'authentication#registering_email_taken',         as: 'registering_email_taken'
  get   '/authentication/successful_registration',     to: 'authentication#successful_registration',         as: 'successful_registration'
  get   '/authentication/confirm_facebook_unlinking',  to: 'authentication#confirm_facebook_unlinking',      as: 'confirm_facebook_unlinking'
  get   '/authentication/before_facebook_unlinking',   to: 'authentication#before_facebook_unlinking',       as: 'before_facebook_unlinking'
  delete '/authentication/process_facebook_unlinking', to: 'authentication#process_facebook_unlinking',      as: 'process_facebook_unlinking'

  #Contributions
  post '/contributions/create_confirmed_contribution', to: 'contributions#create_confirmed_contribution',    as: 'create_confirmed_contribution'

  #CC Widget
  get '/widgets/cc_widget', to: 'widgets#cc_widget',    as: 'cc_widget_js'

  #Conversations
  get '/conversations/node_conversation',              to: 'conversations#node_conversation'
  get '/conversations/node_permalink/:id',             to: 'conversations#node_permalink'
  get '/conversations/rss',                            to: 'conversations#rss',                              as: 'conversation_rss'
  post '/conversations/toggle_rating',                 to: 'conversations#toggle_rating',                    as: 'conversation_contribution_toggle_rating'
  post '/conversations/blog/:id',                      to: 'conversations#create_from_blog_post',            as: 'start_conversation_from_blog_post'
  get '/conversations/:id#node-:contribution_id',      to: 'conversations#show',                             as: 'conversations_node_show'
  get '/conversations/agree_to_be_civil_modal',        to: 'conversations#agree_to_be_civil_modal',          as: 'agree_to_be_civil_modal'
  get '/conversations/permission_to_use_image_modal',  to: 'conversations#permission_to_use_image_modal',    as: 'permission_to_use_image_modal'
  get '/conversations/take_action/:id',                to: 'conversations#take_action',                      as: 'take_conversation_action'

  #Notifications
  post '/notifications/viewed', to: 'notifications#viewed'

  #Curated Feed Item
  get '/curated_feed_items/:curated_feed_id',          to: 'curated_feed_item#curated_feed'

  #Search
  match '/search/results',                             to: 'search#results',                                 as: 'search'
  match '/search/metro_regions/city',                  to: 'search#metro_region_city',                       as: 'metro_region_city_search'

  #Subscriptions
  post '/subscriptions/subscribe',                     to: 'subscriptions#subscribe'
  post '/subscriptions/unsubscribe',                   to: 'subscriptions#unsubscribe'

  #ToS
  get  '/tos/:contribution_id',                        to: 'tos#new',                                        as: 'new_tos'
  post '/tos/:contribution_id',                        to: 'tos#create',                                     as: 'tos'

  #MetroRegions
  post '/metro_regions/filter/cancel',                 to: 'metro_regions#cancel_regions_filter',            as: 'cancel_metro_region_filter'
  post '/metro_regions/filter/:metrocode',             to: 'metro_regions#filter',                           as: 'metro_region_filter'
  post '/metro_regions/filter/',                       to: 'metro_regions#filter',                           as: 'metro_region_filter_form'

  #UnsubscribeDigest
  get '/unsubscribe-me/:id',                           to: 'unsubscribe_digest#unsubscribe_me',              as: 'unsubscribe_confirmation'
  put '/unsubscribe-me/:id',                           to: 'unsubscribe_digest#remove_from_digest'

  #Community
  get '/community',                                    to: 'community#index',                                as: 'community'

  #Static Pages
  match '/about'             => redirect('/pages/about')
  match '/build_the_commons' => redirect('/pages/build-the-commons')
  match '/careers'           => redirect('/pages/jobs')
  match '/contact_us'        => redirect('/pages/contact')
  match '/faq'               => redirect('/pages/faq')
  match '/feeds'             => redirect('/pages/rss-feeds')
  match '/help'              => redirect('/pages/build-the-commons')
  match '/in-the-news'       => redirect('/news')
  match '/jobs'              => redirect('/pages/jobs')
  match '/partners'          => redirect('/pages/partners')
  match '/poster'            => redirect('/pages/poster')
  match '/posters'           => redirect('/pages/poster')
  match '/press'             => redirect('/news')
  match '/principles'        => redirect('/pages/principles'), :as  => 'principles'
  match '/privacy'           => redirect('/pages/privacy')
  match '/sponsorships'      => redirect('/pages/sponsorships')
  match '/team'              => redirect('/pages/team')
  match '/terms'             => redirect('/pages/terms')
  match '/volunteer'         => redirect('/pages/build-the-commons')

#Devise Routes

  devise_for :people, :controllers => { :registrations => 'registrations', :confirmations => 'confirmations', :sessions => 'sessions', :omniauth_callbacks => "registrations/omniauth_callbacks", :passwords => 'passwords'},
                      :path_names => { :sign_in => 'login', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :registration => 'register', :sign_up => 'new' }

  devise_scope :person do
    match '/people/ajax_login', :to=>'sessions#ajax_create', :via=>[:post]
    match '/people/ajax_new_login', :to=>'sessions#ajax_new', :via=>[:get]
    get '/people/secret/fb_auth_forgot_password', to: 'passwords#fb_auth_forgot_password', as: 'fb_auth_forgot_password'
    get "/registrations/omniauth_callbacks/failure", to: "registrations/omniauth_callbacks#failure"
    get '/registrations/principles', to: 'registrations#principles'
    get  "/organizations/register/new", :to => "registrations#new_organization", :as => "new_organization_registration"
    post "/organizations/register", :to => "registrations#create_organization", :as => "organization_registration"
    get '/session_status', to: 'sessions#status', as: 'session_status', defaults: { format: :json }
  end

  #Sort and Filters
  constraints FilterConstraint do
    get 'conversations/:filter', to: 'conversations#filter', as: 'conversations_filter'
  end

#Resource Declared Routes
  #Declare genericly-matched GET routes after Filters

  resources :user, only: [:show, :update, :edit] do
    member do
      get 'mockup'
      delete "destroy_avatar"
      post 'join_as_member'
      delete 'remove_membership'
    end
    collection do
      get 'confirm_membership'
    end
 end

  resources :feeds, only: [:show]

  resources :issues, only: [:index, :show] do
    post 'create_contribution', on: :member
    resources :pages, controller: :managed_issue_pages, only: [:show]
    get '/community', to: 'community#index',   as: 'community'
  end

  resources :notifications

  resources :projects, only: [:index]

  resources :products_services, only: [:index] do
    get '/promotion', to: 'products_services#promotion', on: :collection
    post '/promotion', to: 'products_services#submit_promotion', on: :collection
  end

  resources :conversations, only: [:index, :show, :new, :create, :edit, :update] do
    get :embed, on: :member
    get :updates, on: :member
    get :people, on: :member
    resources :reflections do
      resources :reflection_comments, :path => 'comments'
    end
    get :activities, on: :member
    resources :contributions, only: [:create, :edit, :show, :update, :destroy] do
      get '/moderate', to: 'contributions#moderate', on: :member
      put '/moderate', to: 'contributions#moderated', on: :member
      get '/fb_link', to: 'contributions#fb_link', on: :member
    end
    resources :petitions do
      post :sign, :to => 'petitions#sign', :on => :member
      get :sign, :to => 'petitions#sign_modal', :on => :member
      get :print, :to => 'petitions#print', :on => :member
    end
    resources :actions, :only => [:index]
    resources :votes, controller: :opportunity_votes do
      post :create_response, :on => :member
      get :select_options, :on => :member
      post :create_select_options, :on => :member, :path => 'select_options'
      get :rank_options, :on => :member
      post :create_rank_options, :on => :member, :path => 'rank_options'
    end
  end

  resources :contributions, only: [:destroy]

  resources :votes, controller: :surveys, :only => :show do
    post 'create_response', on: :member
    get 'vote_successful', on: :collection, :as => :successful
  end

  resources :regions, only: [:index, :show]
  resources :invites, only: [:new, :create]
  resources :pages, only: [:show]
  resources :blog, only: [:index, :show] do
    resources :conversations
  end

  resources :content, only: [:index, :show]
  resources :news, only: [:index]

#Namespaces
  namespace "admin" do
    root      to: "dashboard#show"
    resources :articles
    resources :private_labels, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :content_items do#, only: [:index, :show, :new, :create, :update, :destroy]
      resources :content_items_people, :only => [:index, :new, :create, :destroy], :path => 'people'
      resources :content_item_links, :path => 'links'
    end
    get '/content_items/type/:type', to: 'content_items#index', as: 'content_items_type'
    post '/content_items/type/:type/description/create', to: 'content_items#create_description'
    put '/content_items/type/:type/description/:id', to: 'content_items#update_description'
    resources :content_templates
    resources :widget_stats, :only => [:index] do
      get '/*widget_url', to: 'widget_stats#show', on: :collection, as: 'show', format: false
    end
    resources :conversations do
      put 'toggle_staff_pick', on: :member
      post 'update_order', on: :collection
      get 'staff_picked', on: :collection
      put 'move_to_position', on: :member, as: 'move_to_position'
      resources :conversations_people, :only => [:index, :new, :create, :destroy], :path => 'moderators'
    end
    resources :curated_feeds do
      resources :items, controller: :curated_feed_items, only: [ :show, :edit, :create, :update, :destroy ]
    end
    resources :featured_homepage, only: [:index, :update]
    resources :issues do
      resources :pages, controller: :managed_issue_pages
      post 'update_order', on: :collection
    end
    get '/issues/pages/all', to: 'managed_issue_pages#all'
    resources :regions
    resources :email_restrictions
    resources :surveys do
      get 'progress', on: :member
      get 'export_progress', on: :member
      get 'export_voting_records', on: :member
    end
    resources :topics
    resources :people do
      get 'proxies',        on: :collection
      put 'lock_access',    on: :member
      put 'unlock_access',  on: :member
      put 'confirm',        on: :member
      get 'export_members', on: :collection
    end
    resources :user_registrations, only: [:new, :create]
    resources :featured_opportunities do
      get 'change_conversation_selection', on: :collection
    end
    resources :metro_regions do
      get  'display_names',        on: :collection
      get  'edit_display_names',   on: :member
      put  'update_display_names', on: :member
    end
    resources :redirects
  end

  get '*path', to: 'redirects#show'

end
