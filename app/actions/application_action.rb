Cramp::Websocket.backend = :thin

class ApplicationAction < Cramp::Action
	before_start :load_session

	def load_session
		session_id = request.cookies['_session_id']
		@session = Session.where(:session_id => session_id).first
		yield
	end
end
