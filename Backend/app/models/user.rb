class User < ApplicationRecord
	has_one :score
	# 注册验证
	def self.register_authenticate(username, password)
		if username&&password&&username!=""&&password!=""
			if self.find_by_name(username)
				rs = {success: false, msg: "用户名已被注册:)"}
			else
				rs = {success: true}
			end
		else
			rs = {success: false, msg: "格式不符合要求:)"}
		end
		return rs
	end

	# 登录验证
	def self.login_authenticate(username, password)
		if username&&password&&username!=""&&password!=""
			user_res = self.find_by_name_and_password(username, password)
			if user_res
				rs = {success: true, id: user_res.id}
			else
				rs = {success: false, msg: '用户名或密码错误，若为新用户，请先注册:)'}
			end
		else
			rs = {success: false, msg: '格式不符合要求:)'}
		end
		return rs
	end

	# 
end
