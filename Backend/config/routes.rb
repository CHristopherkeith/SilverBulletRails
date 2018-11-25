Rails.application.routes.draw do
	resources :silver_bullets do
		collection do
			get 'foo'
			get 'redirect'
			get 'login'
			post 'verify_score'
			get 'game_initialize'
		end
	end
	post 'users/register', to: 'users#register'
	post 'users/login', to: 'users#login'
	post 'users/logout', to: 'users#logout'
	get 'users/get_current_user', to: 'users#get_current_user'
end
