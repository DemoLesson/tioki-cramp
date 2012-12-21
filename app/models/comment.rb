class Comment < ActiveRecord::Base
	set_table_name :comments
	belongs_to :user

	# Commentable
	belongs_to :commentable, :polymorphic => true

	# Notifications that happened since the arg
	def self.since(time)
		time = 7.days.ago if time.nil?
		time = time.created_at if time.is_a?(Comment)
		where('created_at > ?', time).order('created_at DESC')
	end

	def owner
		_class, _id = read_attribute(:commentable_type).split(':')
		_class.constantize.find(commentable_id)
	end

	def link
		"/discussions/#{owner.to_param}#c#{id}"
	end
end
