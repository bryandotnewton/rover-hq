Rails.application.routes.draw do
  resources :commands
  root 'commands#index' # shortcut for the above
end
