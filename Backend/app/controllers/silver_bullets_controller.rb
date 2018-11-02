class SilverBulletsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	# layout "silver_bullets"
	def index
		
	end
	def foo
		p params
		p 'ffffffffffff'
		p params[:a]
		rs = {bar: "bar"}
		render json: params
	end
end
