Rails.application.routes.draw do
  root to: "contact_files#index"
  devise_for :users

  authenticate :user do

    scope :contacts do
      get '/' => 'contacts#index', as: :contacts
      get 'show/:id' => 'contacts#show', as: :show_contacts
      get 'open_modal/:id' => 'contacts#open_modal', as: :open_modal_contacts
      post 'process_csv/:id' => 'contacts#process_csv', as: :process_csv_contacts
    end

    scope :contact_files do
      get '/' => 'contact_files#index', as: :contact_files
      get '/new' => 'contact_files#new', as: :new_contact_file
      post 'upload' => 'contact_files#upload', as: :upload_contact_file
    end

  end
  
end
