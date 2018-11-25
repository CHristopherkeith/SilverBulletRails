class UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	# layout "silver_bulletsff"
	# 注册
	def register
		rs = {success: true, data: nil, msg: ""}
		begin
			authenticate_rs = User.register_authenticate(params[:username], params[:password])
			if authenticate_rs[:success]
				User.create(name: params[:username], password: params[:password])
			else
				rs = {success: false, data: nil, msg: authenticate_rs[:msg]}
			end
		rescue Exception => e
			puts e.message
			puts $@
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	# 登录
	def login
		rs = {success: true, data: nil, msg: ""}
		current_user()
		begin
			authenticate_rs = User.login_authenticate(params[:username], params[:password])
			if authenticate_rs[:success]
				# 把用户的 ID 存储在会话中，以便后续请求使用
				session[:current_user_id] = authenticate_rs[:id]
				rs = {success: true, data: {username: params[:username]}, msg: ""}
			else
				rs = {success: false, data: nil, msg: authenticate_rs[:msg]}
			end
		rescue Exception => e
			puts e.message
			puts $@
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	# 退出
	def logout
		rs = {success: true, data: nil, msg: ""}
		begin
			# 从会话中删除用户的 ID
			@_current_user = session[:current_user_id] = nil
		rescue Exception => e
			puts e.message
			puts $@
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end	

	# 现在登录的用户
	def get_current_user
		begin
			current_user()
			if @_current_user
				rs = {success: true, data: {username: @_current_user.name}, msg: ""}
			else
				rs = {success: false, data: nil, msg: ""}
			end
		rescue Exception => e
			puts e.message
			puts $@
			rs = {success: false, data: nil, msg: e.message}
		end
		render json:rs
	end

	# 注销
	def destroy
		rs = {success: true, data: nil, msg: ""}
		# begin
		# 	# 从会话中删除用户的 ID
		# 	@_current_user = session[:current_user_id] = nil
		# rescue Exception => e
		# 	puts e.message
		# 	puts $@
		# 	rs = {success: false, data: nil, msg: e.message}
		# end
		render json:rs
	end	
end
