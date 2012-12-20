class User < ActiveRecord::Base
	set_table_name :users

	# Notifications that happened since the arg
	def self.since(time)
		time = 1.month.ago if time.nil?
		time = time.last_login if time.is_a?(User)
		where('last_login > ?', time).order('last_login DESC')
	end

	def url
		"/profile/#{slug}"
	end

	def link
		"<a href=\"#{url}\">#{name}</a>"
	end
end
