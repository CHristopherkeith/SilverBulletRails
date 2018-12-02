class SilverBulletsController < ApplicationController
	skip_before_action :verify_authenticity_token
	def index
		# headers['Access-Control-Allow-Origin'] = "*"
	end
	# def foo
	# 	p params
	# 	p 'ffffffffffff'
	# 	p params[:a]
	# 	session
	# 	rs = {success: false, data: nil, msg: nil, redirect: "login"}
	# 	session[:current_user_id] = 1
	# 	render json: rs
	# end
	# def redirect
	# 	p '1111111111111111111111'
	# 	# puts params
	# 	puts request.url
	# 	puts request.protocol
	# 	puts request.host_with_port
	# 	p '222222222222222'
	# 	rs = {a:'a'}
	# 	redirect_to "#{request.protocol}#{request.host_with_port}/silver_bullets/#/login"
	# end

	# 验证分数
	def verify_score
		begin
			rs = {success: true, data: nil, msg: ''}
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
				if !verify_rs[:success]
					rs = {success: false, data: nil, msg: verify_rs[:msg]}
				end
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
		initial_position = Array.new(cnt){[Random.rand, Random.rand]}
		# initial_position = Array.new(cnt){[0, 0]}
		# initial_position = [[0,0],[0.1,0.1],[0.2,0.2]];
		# initial_position = [[0,0]];
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
			return rs
		else
			# 判断时间间隔，不能小于初始化时需要的时间间隔
			cnt = origin_data[:cnt].to_i
			if 1.2*cnt-0.5*(cnt-1)+0.05 >= Time.parse(data[:time_token]) - Time.parse(origin_data[:time_token])
				rs = {success: false, data: nil, msg: '数据验证失败：游戏时长过短'}
				return rs
			end
			# 分析点击事件行为是否合理
			analyse_rs = analyse_position(data[:position], origin_data[:initial_position])
			if !analyse_rs[:success]
				rs = {success: false, data: nil, msg: '数据验证失败：位置数据异常，可能存在作弊行为'}
				return rs
			end
			# 验证分数
			if analyse_rs[:data][:score] < data[:score]
				rs = {success: false, data: nil, msg: '数据验证失败：分数数据异常，可能存在作弊行为'}
				return rs
			end
		end
		return rs
	end

	# 分析位置数据
	def analyse_position(position_data, initial_position)
		rs = {success: true, data: nil, msg: ''}
		position_data = JSON.parse(position_data)
		hits = 0
		misses = 0
		missed_targets = 0
		score = 0
		position_data.each{|item|
			if item["hit"]
				hits = hits +1
				item_index = item["index"]
				# 判断时间轴是否有效
				if item["time"]<700*item_index || item["time"]>700*item_index + 1200
					rs = {success: false, data: nil, msg: '数据验证失败：时间数据异常，可能存在作弊行为'}
					return rs
				end
				# 判断位置是否有效
				x = item["x"] # 点击x位置
				y = item["y"] # 点击y位置
				rx = initial_position[item_index][0]*450 # 圆心x位置
				ry = initial_position[item_index][1]*450 # 圆心y位置
				if (x-rx)**2+(y-ry)**2>20**2+50
					rs = {success: false, data: nil, msg: '数据验证失败：位置数据异常，可能存在作弊行为'}
					return rs
				end
			else
				misses = misses +1
			end
		}
		p hits, misses, initial_position.length - hits
		score = 300*hits - 100*misses - 300*(initial_position.length - hits)
		p score
		rs[:data] = {score: score}
		return rs
	end
end
