Rails.application.routes.draw do
	resources :silver_bullets do
		collection do
			post 'foo'
		end
	end
end
