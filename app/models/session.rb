class Session < ActiveRecord::Base
	set_table_name :sessions

	# Get the data on the sessions table
	def data; Marshal.load(Base64.decode64(read_attribute(:data))); end

	# Notifications that happened since the arg
	def self.since(time)
		time = 1.month.ago if time.nil?
		time = time.created_at if time.is_a?(Session)
		where('created_at > ?', time).order('created_at DESC')
	end
end
