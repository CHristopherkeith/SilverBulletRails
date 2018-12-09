class Score < ApplicationRecord
	belongs_to :user
	# 创建或更新分数
	def self.create_or_update_score(current_user, score, current_user_id)
		current_score = current_user.score
		if current_score
			current_score.update!({
				score: score
			})
		else
			current_user.create_score!({
				user_id: current_user_id,
				score: score
			})
		end
	end
end
