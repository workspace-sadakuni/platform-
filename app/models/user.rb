class User < ApplicationRecord
	has_secure_password

	validates :name, {presence: true}#, uniqueness: true}
	validates :email, {presence: true, uniqueness: true}

	def self.find_or_create_from_auth_hash(auth_hash)
		provider = auth_hash[:provider] #providerがどのサービスか判断
		uid = auth_hash[:uid]
		name = auth_hash[:info][:name]
		image_url = auth_hash[:info][:image]
		

		self.find_or_create_by(provider: provider,uid: uid) do |user|
			user.name = name
			user.image_url = image_url
			user.email = "#{name}-#{auth_hash.provider}@example.com"
			user.password = "#{name}_default_password"
		end
	end
	
	def posts
		return Post.where(user_id: self.id)
	end

end
