class User < ApplicationRecord
	def self.authenticate(username, password)
		rs = {success: true, msg: nil}
		if username&&password&&username!=""&&password!=""
			if self.find_by_name(username)
				rs = {success: false, msg: '用户名已被注册'}
			else
				rs = {success: true}
			end
		else
			rs = {success: false, msg: '格式不符合要求'}
		end
		return rs
	end
end
