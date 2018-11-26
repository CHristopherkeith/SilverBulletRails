class SilverBulletsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		# headers['Access-Control-Allow-Origin'] = "*"
	end
	def foo
		p params
		p 'ffffffffffff'
		p params[:a]
		session
		rs = {success: false, data: nil, msg: nil, redirect: "login"}
		session[:current_user_id] = 1
		# redirect_to "#{request.protocol}#{request.host_with_port}/silver_bullets/#/login"
		# response.headers["REDIRECT"] = "REDIRECT";
		# response.headers["CONTEXTPATH"] = "login";
		# response.headers["foo11"] = "bar11"
		# response.headers.delete("foo11")
		render json: rs
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

	# 验证分数
	def verify_score
		begin
			current_user()
			if @_current_user
				rs = {success: true, data: nil, msg: nil}
			else
				rs = {success: false, data: nil, msg: nil, redirect: "login"}
			end
		rescue Exception => e
			# puts $!
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	# 游戏初始化
	def game_initialize
		begin
			current_user()
			cnt = params[:cnt] || 2
			initial_position = get_initial_position(cnt.to_i)
			rs = {success: true, data: {initial_position: initial_position}, msg: nil}
			if @_current_user
				session[:initial_token] = Time.now
				session[:initial_position] = initial_position
			end
		rescue Exception => e
			# puts $!
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	private
	def get_initial_position(cnt=10)
		# initial_position = [{left:1, top:1}]
		initial_position = Array.new(cnt){{left:Random.rand, top:Random.rand}}
		return initial_position
	end
end
