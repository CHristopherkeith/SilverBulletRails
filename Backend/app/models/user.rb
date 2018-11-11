class User < ApplicationRecord
	def self.authenticate(username, password)
		return true
	end
end
