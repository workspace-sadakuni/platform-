class Post < ApplicationRecord
	validates :content, {presence: true, length: {maximum: 140}}
	validates :title, {presence: true, length: {maximum: 25}}
	validates :started_at, {length: {maximum: 16}}
	validates :finish_at, {length: {maximum: 16}}
	validates :user_id, {presence: true}

	def user
		return User.find_by(id: self.user_id)
	end
	
end
