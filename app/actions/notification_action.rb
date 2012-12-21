class NotificationAction < ApplicationAction
	self.transport = :sse
	use_fiber_pool

	on_start :send_latest_notifications
	periodic_timer :send_latest_notifications, :every => 2

	def send_latest_notifications
		return render [].to_json if @session.user.nil?

		@latest_notification ||= nil
		new_notifications = Notification.owner(@session.user).since(@latest_notification).limit(10)
		@latest_notification = new_notifications.first unless new_notifications.empty?

		# Lets get our data together
		data = Array.new

		for note in new_notifications.reverse
			data << {:url => note.url, :message => note.message, :since => note.since}
		end

		render data.to_json
	end
end
