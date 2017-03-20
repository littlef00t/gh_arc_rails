Rails.application.routes.draw do
  root "leaders#index"
  match '/request' => 'leaders#create', via: :get
end
