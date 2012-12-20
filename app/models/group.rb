class Group < ActiveRecord::Base
	set_table_name :groups

	# Notifications that happened since the arg
	def self.since(time)
		time = 7.days.ago if time.nil?
		time = time.created_at if time.is_a?(Group)
		where('created_at > ?', time).order('created_at DESC')
	end

	def url
		"/groups/#{id}"
	end

	def link
		"<a href=\"#{url}\">#{name}</a>"
	end
end
