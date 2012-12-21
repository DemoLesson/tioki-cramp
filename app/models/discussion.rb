class Discussion < ActiveRecord::Base
	set_table_name :discussions
	belongs_to :user

	# Notifications that happened since the arg
	def self.since(time)
		time = 7.days.ago if time.nil?
		time = time.created_at if time.is_a?(Discussion)
		where('created_at > ?', time).order('created_at DESC')
	end

	def to_param
		"#{id}-#{title.parameterize}"
	end

	def owner
		return nil if read_attribute(:owner).nil?
		_class, _id = read_attribute(:owner).split(':')
		_class.constantize.find(_id)
	end

	def url
		"/discussions/#{to_param}"
	end

	def link
		"<a href=\"#{url}\">#{title}</a>"
	end
end
