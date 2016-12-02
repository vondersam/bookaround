Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
  devise_for :views


  resources 'physical_books' do
    resources 'users'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

