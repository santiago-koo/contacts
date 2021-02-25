Rails.application.routes.draw do
  root to: "contacts#index"
  devise_for :users
  
  scope :contacts do
    get '/' => 'contacts#index', as: :contacts
    post 'manage_csv' => 'contacts#manage_csv', as: :contacts_manage_csv
  end

end
