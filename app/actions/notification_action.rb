class NotificationAction < ApplicationAction
	self.transport = :sse
	use_fiber_pool

	on_start :send_latest_notifications
	periodic_timer :send_latest_notifications, :every => 2

	def send_latest_notifications
		@latest_notification ||= nil
		new_notifications = Notification.owner(@session.data['user']).since(@latest_notification).limit(10)
		@latest_notification = new_notifications.first unless new_notifications.empty?
		render new_notifications.to_json
	end
end
