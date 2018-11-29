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
		redirect_to "#{request.protocol}#{request.host_with_port}/silver_bullets/#/login"
	end

	# 验证分数
	def verify_score
		begin
			current_user()
			if @_current_user
				to_verify_data = {
					time_token: params[:timeToken],
					position: params[:position],
					score: params[:score]
				}
				origin_data = {
					time_token: session[:initial_token],
					initial_position: session[:initial_position],
					cnt: session[:cnt]
				}
				verify_rs = verify_data(to_verify_data, origin_data)
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
				session[:cnt] = cnt
				session[:initial_position] = initial_position
			end
		rescue Exception => e
			# puts $!
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	private

	# 初始化游戏
	def get_initial_position(cnt=10)
		# initial_position = Array.new(cnt){[Random.rand, Random.rand]}
		initial_position = Array.new(cnt){[1, 1]}
		return initial_position
	end

	# 验证数据
	# 时间token+位置+分数
	# 参数 data={time_token:nil, position: nil, score: nil}
	def verify_data(data, origin_data)
		require "time"
		rs = {success: true, data: nil, msg: ''}
		if !(data[:time_token]&&data[:position]&&data[:score])
			rs = {success: false, data: nil, msg: '无效数据'}
		else
			puts '1'*50
			puts data
			puts '2'*50
			puts origin_data
			puts '3'*50
			puts Time.parse(origin_data[:time_token])
			puts Time.parse(data[:time_token])
			puts Time.parse(data[:time_token]) - Time.parse(origin_data[:time_token])
			puts '4'*50
			# #################

			# 判断时间间隔，不能小于初始化时需要的时间间隔
			if origin_data[:cnt].to_i >= Time.parse(data[:time_token]) - Time.parse(origin_data[:time_token])
				rs = {success: false, data: nil, msg: '数据验证失败：游戏时长过短'}
			# elsif
			end
		end
		puts '5'*50
		puts rs
		return rs
	end
end
