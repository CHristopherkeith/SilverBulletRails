class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
	
	private
	# 使用会话中 :current_user_id  键存储的 ID 查找用户
	# Rails 应用经常这样处理用户登录
	# 登录后设定这个会话值，退出后删除这个会话值
	def current_user
		@_current_user ||= session[:current_user_id] && User.find_by(id: session[:current_user_id])
		# @_current_user = 'hhhhhhhhhh'
	end
end
