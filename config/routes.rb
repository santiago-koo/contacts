Rails.application.routes.draw do
  root to: 'contact_files#index'
  devise_for :users

  authenticate :user do
    resources :contact_files do
      member do
        get 'failed_contacts'
        get 'open_modal'
        post 'process_csv'
      end
    end
  end
end
