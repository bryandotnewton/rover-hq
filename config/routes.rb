Rails.application.routes.draw do
  resources :commands
  root 'commands#new' # shortcut for the above
end
