Rails.application.routes.draw do
  get 'wording/game'

  get 'wording/score'

  get '/game', to: 'wording#game'

  get '/score', to: 'wording#score'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
