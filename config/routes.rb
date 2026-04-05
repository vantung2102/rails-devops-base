Rails.application.routes.draw do
  root 'home#index'

  draw(:system)
end
