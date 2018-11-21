Rails.application.routes.draw do
	resources :silver_bullets do
		collection do
			get 'foo'
			get 'redirect'
			get 'login'
		end
	end
	post 'users/register', to: 'users#register'
	post 'users/login', to: 'users#login'
end
