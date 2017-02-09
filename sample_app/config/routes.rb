Rails.application.routes.draw do
  get 'static_pages/home'
#cool
  get 'static_pages/help'

  get 'static_pages/about'

  root 'application#hello'
end
