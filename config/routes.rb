# Check out https://github.com/joshbuddy/http_router for more information on HttpRouter
HttpRouter.new do
  def add!(route); add('/cramp' + route); end
  add!('/').to(HomeAction)
  add!('/notifications').to(NotificationAction)
end
