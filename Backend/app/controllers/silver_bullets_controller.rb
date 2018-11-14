class SilverBulletsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	# layout "silver_bullets"
	def index
		
	end
	def foo
		p params
		p 'ffffffffffff'
		p params[:a]
		session
		rs = {bar: "bar"}
		session[:current_user_id] = 1
		render json: params
	end
	def redirect
		p '1111111111111111111111'
		# puts params
		puts request.url
		puts request.protocol
		puts request.host_with_port
		p '222222222222222'
		rs = {a:'a'}
		# response.headers["location"] = "www.baidu.com"
		# redirect_to(:action => 'login')
		# redirect_to(:controller=>'silver_bullets#/login')
		# redirect_to "http://localhost:3000/silver_bullets/#/login"
		redirect_to "#{request.protocol}#{request.host_with_port}/silver_bullets/#/login"
		# redirect_to "https://www.baidu.com/"
		# redirect_to( :location=>"www.baidu.com")
		# render json:rs
	end
	def login
		rs = {b:'b'}
		render json:rs
	end
end
