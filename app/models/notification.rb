class Notification < ActiveRecord::Base
	include ModelUtils

	set_table_name :notifications
	belongs_to :user

	def self.owner(user)
		where(:user_id => user.id)
	end

	# Notifications that happened since the arg
	def self.since(time)
		time = 7.days.ago if time.nil?
		time = time.created_at if time.is_a?(Notification)
		where('created_at > ?', time).order('created_at DESC')
	end

	def tag
		_class, _id = notifiable_type.split(':')
		_class.constantize.find(_id)
	end

	def triggered
		tag.user
	end

	def message
		_class = notifiable_type.split(':').first

		ret = String.new
		case _class
		when 'Comment'
			ret = "#{triggered.link} replied to #{tag.owner.link}."
		when 'Discussion'
			ret = "#{triggered.link} created a discussion #{tag.link}." if tag.owner.nil?
			ret = "#{triggered.link} created the discussion #{tag.link} on #{tag.owner.link}."
		when 'Favorite'
			ret = "#{triggered.link} favorited a post of yours."
		when 'Application'
			ret = "#{triggered.link} updated a job application for #{tag.job.title}" if dashboard == 'recruiter'
			ret = "#{triggered.link} updated a job application for #{tag.job.title}" if dashboard != 'recruiter'
		when 'Interview'
			ret = "#{triggered.link} responded to the interview request for #{tag.job.title}" if dashboard == 'recruiter'
			ret = "#{triggered.link} updated a interview request for #{tag.job.title}" if dashboard != 'recruiter'
		end

		return ret
	end

	def since
		relative_time(created_at)
	end

	def url
		_class = notifiable_type.split(':').first

		case _class
		when 'Comment', 'Favorite', 'Application', 'Interview', 'Discussion'
			tag.url# rescue nil
		end
	end
end
