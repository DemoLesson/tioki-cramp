class Notification < ActiveRecord::Base
	set_table_name :notifications

	def self.owner(user)
		where(:user_id => user.id)
	end

	# Notifications that happened since the arg
	def self.since(time)
		time = 7.days.ago if time.nil?
		time = time.created_at if time.is_a?(Notification)
		where('created_at > ?', time).order('created_at DESC')
	end
end
