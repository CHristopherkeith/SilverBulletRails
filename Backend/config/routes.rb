Rails.application.routes.draw do
	resources :silver_bullets do
		collection do
			post 'foo'
		end
	end
	get 'user_register', to: 'users#register'
end
